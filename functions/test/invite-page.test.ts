import { exports } from "cloudflare:workers";
import { describe, expect, it } from "vitest";

const BASE = "https://plants.pampait.pl";
const CODE = "Ab3dEf6hIj9k";

describe("GET /i/:code", () => {
  it("serves a small, script-free page that never echoes the code", async () => {
    const res = await exports.default.fetch(`${BASE}/i/${CODE}`);
    const html = await res.text();

    expect(res.status).toBe(200);
    expect(html).toContain("invited");
    expect(html).not.toContain(CODE);
    expect(html).not.toContain("<script");
    expect(res.headers.get("cache-control")).toBe("no-store");
    expect(res.headers.get("x-robots-tag")).toBe("noindex, nofollow");
    expect(res.headers.get("set-cookie")).toBeNull();
    expect(new TextEncoder().encode(html).length).toBeLessThan(50 * 1024);
  });

  it.each(["short", `${CODE}x`, "Ab3dEf6hIj9-", `${CODE}/extra`])(
    "returns 404 for a malformed code: %s",
    async (code) => {
      expect((await exports.default.fetch(`${BASE}/i/${code}`)).status).toBe(404);
    },
  );
});
