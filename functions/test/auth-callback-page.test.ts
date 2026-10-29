import { exports } from "cloudflare:workers";
import { describe, expect, it } from "vitest";

const BASE = "https://plants.pampait.pl";
const CODE = "0192f3c4-5a6b-7c8d-9e0f-1a2b3c4d5e99";

describe("GET /auth/callback", () => {
  it("asks to open the link on the phone, never echoing the code", async () => {
    const res = await exports.default.fetch(`${BASE}/auth/callback?code=${CODE}`);
    const html = await res.text();

    expect(res.status).toBe(200);
    expect(html).toContain("Open this link on your phone");
    expect(html).not.toContain(CODE);
    expect(html).not.toContain("<script");
    expect(html).not.toMatch(/https?:\/\//);
    expect(res.headers.get("cache-control")).toBe("no-store");
    expect(res.headers.get("x-robots-tag")).toBe("noindex, nofollow");
    expect(res.headers.get("set-cookie")).toBeNull();
  });

  it("serves nothing else under /auth", async () => {
    expect((await exports.default.fetch(`${BASE}/auth/other`)).status).toBe(404);
  });
});
