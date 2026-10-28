import { DurableObject } from "cloudflare:workers";

/** Set by the Worker on the internal request; never read from a client. */
export const LIVE_USER_HEADER = "X-Live-User";
export const LIVE_EXPIRES_HEADER = "X-Live-Expires";

/** Enough for every phone in a household, with room to spare. */
export const MAX_SOCKETS = 50;

/** Close codes the app acts on (private range 4000-4999). */
export const CLOSE_TOKEN_EXPIRED = 4001;
export const CLOSE_NOT_MEMBER = 4003;

interface Attachment {
  userId: string;
  /** Access token expiry, Unix seconds. */
  expires: number;
}

/**
 * One per household (ADR-0013, ADR-0020). Holds its members' foreground
 * WebSockets with the hibernation API, so idle sockets cost nothing, and
 * broadcasts "something changed" signals. Never carries household data.
 */
export class HouseholdLive extends DurableObject {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env);
    // Keepalive pings are answered without waking the object.
    ctx.setWebSocketAutoResponse(new WebSocketRequestResponsePair("ping", "pong"));
  }

  /** Accepts a socket the Worker has already authorised for this household. */
  override fetch(request: Request): Response {
    const userId = request.headers.get(LIVE_USER_HEADER);
    const expires = Number(request.headers.get(LIVE_EXPIRES_HEADER));
    if (!userId || !Number.isFinite(expires) || request.headers.get("Upgrade") !== "websocket") {
      return new Response(null, { status: 400 });
    }
    if (this.ctx.getWebSockets().length >= MAX_SOCKETS) {
      return new Response(null, { status: 429 });
    }

    const { 0: client, 1: server } = new WebSocketPair();
    this.ctx.acceptWebSocket(server, [userId]);
    server.serializeAttachment({ userId, expires } satisfies Attachment);
    return new Response(null, { status: 101, webSocket: client });
  }

  /**
   * Tells every connected member that something changed, so they pull.
   * Sockets whose access token has expired are closed instead; the app
   * reconnects with a fresh one. Returns how many were signalled.
   */
  changed(): number {
    const now = Date.now() / 1000;
    const message = JSON.stringify({ type: "changed", v: 1 });
    let sent = 0;
    for (const ws of this.ctx.getWebSockets()) {
      const { expires } = ws.deserializeAttachment() as Attachment;
      if (expires <= now) {
        safeClose(ws, CLOSE_TOKEN_EXPIRED, "token_expired");
        continue;
      }
      try {
        ws.send(message);
        sent++;
      } catch {
        // Already closing; the runtime cleans it up.
      }
    }
    return sent;
  }

  /** Closes a member's sockets when they leave the household (FR-7). */
  disconnect(userId: string): void {
    for (const ws of this.ctx.getWebSockets(userId)) {
      safeClose(ws, CLOSE_NOT_MEMBER, "not_member");
    }
  }

  /** Clients only send pings, answered automatically; anything else is ignored. */
  override webSocketMessage(): void {
    // Nothing to do: the socket is one-way.
  }

  override webSocketClose(ws: WebSocket, code: number): void {
    // 1005 and 1006 can't be sent back; close normally instead.
    safeClose(ws, code === 1005 || code === 1006 ? 1000 : code, "");
  }
}

function safeClose(ws: WebSocket, code: number, reason: string): void {
  try {
    ws.close(code, reason);
  } catch {
    // Already closed.
  }
}
