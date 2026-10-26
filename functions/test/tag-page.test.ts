import { exports } from "cloudflare:workers";
import { describe, expect, it } from "vitest";

const BASE = "https://plants.pampait.pl";
const TOKEN = "AbCdEfGhIjKlMnOpQrStUv";

describe("GET /p/:token", () => {
  it("serves a small, script-free, non-indexed page", async () => {
    const res = await exports.default.fetch(`${BASE}/p/${TOKEN}`);
    const html = await res.text();

    expect(res.status).toBe(200);
    expect(res.headers.get("content-type")).toMatch(/^text\/html/);
    expect(res.headers.get("cache-control")).toBe("no-store");
    expect(res.headers.get("x-robots-tag")).toBe("noindex, nofollow");
    expect(res.headers.get("set-cookie")).toBeNull();
    expect(html).not.toContain("<script");
    expect(html).not.toContain(TOKEN);
    expect(new TextEncoder().encode(html).length).toBeLessThan(50 * 1024);
  });

  it.each(["short", `${TOKEN}x`, "AbCdEfGhIjKlMnOpQrSt-v", `${TOKEN}/extra`])(
    "returns 404 for a malformed token: %s",
    async (token) => {
      const res = await exports.default.fetch(`${BASE}/p/${token}`);

      expect(res.status).toBe(404);
    },
  );
});
