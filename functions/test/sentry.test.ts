import type { ErrorEvent } from "@sentry/cloudflare";
import { describe, expect, it } from "vitest";
import { scrubEvent } from "../src/lib/sentry";

describe("scrubEvent", () => {
  it("redacts tag tokens in API paths too", () => {
    const event: ErrorEvent = {
      type: undefined,
      message: "GET /v1/tags/AbCdEfGhIjKlMnOpQrStUv failed",
    };

    expect(scrubEvent(event).message).toBe("GET /v1/tags/[token] failed");
  });

  it("removes user, cookies, body and sensitive headers", () => {
    const event: ErrorEvent = {
      type: undefined,
      user: { email: "a@b.com" },
      request: {
        url: "https://plants.pampait.pl/p/AbC123xyz",
        cookies: { sid: "1" },
        data: { email: "a@b.com" },
        query_string: "token=abc",
        headers: { Authorization: "Bearer x", "user-agent": "test" },
      },
      message: "failed for jane@example.com",
      exception: { values: [{ value: "bad tag /p/QwErTy" }] },
      extra: { displayName: "Jane", count: 2 },
    };

    const out = scrubEvent(event);

    expect(out.user).toBeUndefined();
    expect(out.request?.cookies).toBeUndefined();
    expect(out.request?.data).toBeUndefined();
    expect(out.request?.query_string).toBe("[redacted]");
    expect(out.request?.url).toBe("https://plants.pampait.pl/p/[token]");
    expect(out.request?.headers).toEqual({
      Authorization: "[redacted]",
      "user-agent": "test",
    });
    expect(out.message).toBe("failed for [email]");
    expect(out.exception?.values?.[0]?.value).toBe("bad tag /p/[token]");
    expect(out.extra).toEqual({ displayName: "[redacted]", count: 2 });
  });

  it("tolerates a minimal event", () => {
    const event: ErrorEvent = { type: undefined };

    expect(scrubEvent(event)).toEqual({ type: undefined });
  });
});
