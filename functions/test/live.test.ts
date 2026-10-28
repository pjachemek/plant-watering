import { Client } from "pg";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { CLOSE_NOT_MEMBER, CLOSE_TOKEN_EXPIRED } from "../src/live/household-live";
import { uuidv7 } from "../src/lib/ids";
import { callerAs, testApp, token, VERSION_HEADERS } from "./helpers";

// Live updates end to end (ADR-0013, ADR-0020): a real WebSocket through the
// gateway to the household's Durable Object, against the local database.
const ADMIN_URL = "postgres://postgres:postgres@127.0.0.1:54322/postgres";
const ANN = "0192f3c4-0000-7000-8000-00000007a001";
const BOB = "0192f3c4-0000-7000-8000-00000007b002";
const CAT = "0192f3c4-0000-7000-8000-00000007c003";

const admin = new Client({ connectionString: ADMIN_URL });
admin.on("error", () => undefined);
const call = testApp();
const as = callerAs(call);
let home = "";

beforeAll(async () => {
  await admin.connect();
  await admin.query(
    `insert into auth.users (id, email) values ($1, 'ann.live@example.test'),
     ($2, 'bob.live@example.test'), ($3, 'cat.live@example.test') on conflict (id) do nothing`,
    [ANN, BOB, CAT],
  );
  home = (await as(ANN, "POST", "/households", { name: "Live", display_name: "Ann" })).body
    .id as string;
});

afterAll(async () => {
  await admin.query("delete from public.households where id = $1", [home]);
  await admin.query("delete from auth.users where id in ($1, $2, $3)", [ANN, BOB, CAT]);
  await admin.end();
});

type LiveEvent = { kind: "message"; data: string } | { kind: "close"; code: number };

/** An open socket that queues what arrives, so tests can await it in order. */
class Socket {
  private readonly events: LiveEvent[] = [];
  private waiting: ((event: LiveEvent) => void) | undefined;

  constructor(readonly ws: WebSocket) {
    ws.accept();
    ws.addEventListener("message", (e) => {
      this.push({ kind: "message", data: e.data as string });
    });
    ws.addEventListener("close", (e) => {
      this.push({ kind: "close", code: e.code });
    });
  }

  private push(event: LiveEvent) {
    const waiting = this.waiting;
    this.waiting = undefined;
    if (waiting) waiting(event);
    else this.events.push(event);
  }

  next(timeoutMs = 3000): Promise<LiveEvent> {
    const queued = this.events.shift();
    if (queued) return Promise.resolve(queued);
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        reject(new Error("no live event"));
      }, timeoutMs);
      this.waiting = (event) => {
        clearTimeout(timer);
        resolve(event);
      };
    });
  }
}

async function open(user: string, accessToken?: string, household = home) {
  return call(`/live?household_id=${household}`, {
    headers: {
      ...VERSION_HEADERS,
      Authorization: `Bearer ${accessToken ?? (await token({ sub: user }))}`,
      Upgrade: "websocket",
    },
  });
}

async function connect(user: string, accessToken?: string) {
  const res = await open(user, accessToken);
  expect(res.status).toBe(101);
  if (!res.webSocket) throw new Error("no socket");
  return new Socket(res.webSocket);
}

const pushPlant = (user: string, nickname: string) =>
  as(
    user,
    "POST",
    "/sync/push",
    {
      household_id: home,
      changes: [
        {
          change_id: uuidv7(),
          entity: "plant",
          op: "upsert",
          id: uuidv7(),
          plant: { nickname, preset_id: "monstera" },
        },
      ],
    },
    { "Idempotency-Key": uuidv7() },
  );

const CHANGED = { kind: "message", data: JSON.stringify({ type: "changed", v: 1 }) };

describe("live updates (FR-2, NFR Sync)", () => {
  it("refuses a household the caller isn't in (404), and a request that isn't an upgrade (400)", async () => {
    expect((await open(CAT)).status).toBe(404);

    const plain = await call(`/live?household_id=${home}`, {
      headers: { ...VERSION_HEADERS, Authorization: `Bearer ${await token({ sub: ANN })}` },
    });
    expect(plain.status).toBe(400);
  });

  it("answers pings, and signals every open app after a push", async () => {
    const ann = await connect(ANN);
    ann.ws.send("ping");
    expect(await ann.next()).toEqual({ kind: "message", data: "pong" });

    const invite = await as(ANN, "POST", "/invites", { household_id: home });
    await as(BOB, "POST", "/invites/accept", { code: invite.body.code, display_name: "Bob" });
    expect(await ann.next()).toEqual(CHANGED); // Bob joined

    const bob = await connect(BOB);
    await pushPlant(ANN, "Monty");
    expect(await bob.next()).toEqual(CHANGED);
    expect(await ann.next()).toEqual(CHANGED);
    ann.ws.close(1000);
    bob.ws.close(1000);
  });

  it("closes a member's socket when they leave, and tells the others", async () => {
    const ann = await connect(ANN);
    const bob = await connect(BOB);

    const left = await as(BOB, "POST", `/households/${home}/leave`, {
      confirm_delete_household: false,
    });
    expect(left.status).toBe(204);
    expect(await bob.next()).toEqual({ kind: "close", code: CLOSE_NOT_MEMBER });
    expect(await ann.next()).toEqual(CHANGED);
    ann.ws.close(1000);
  });

  it("closes a socket whose access token has expired instead of signalling it", async () => {
    const shortLived = await token({ sub: ANN }, { expiresIn: "1s" });
    const ann = await connect(ANN, shortLived);
    await new Promise((resolve) => setTimeout(resolve, 1500));

    await pushPlant(ANN, "Late");
    expect(await ann.next()).toEqual({ kind: "close", code: CLOSE_TOKEN_EXPIRED });
  });
});
