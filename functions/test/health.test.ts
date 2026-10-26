import { exports } from "cloudflare:workers";
import { describe, expect, it } from "vitest";
import { createApp } from "../src/app";

describe("GET /health", () => {
  it("returns ok with the environment name", async () => {
    const res = await exports.default.fetch("https://plants.pampait.pl/health");

    expect(res.status).toBe(200);
    expect(res.headers.get("cache-control")).toBe("no-store");
    expect(await res.json()).toEqual({ status: "ok", env: "dev" });
  });

  it("sets security headers", async () => {
    const res = await exports.default.fetch("https://plants.pampait.pl/health");

    expect(res.headers.get("strict-transport-security")).toContain("max-age=");
    expect(res.headers.get("x-content-type-options")).toBe("nosniff");
    expect(res.headers.get("content-security-policy")).toContain("default-src 'none'");
  });
});

describe("unknown routes", () => {
  it("return 404", async () => {
    const res = await exports.default.fetch("https://plants.pampait.pl/nope");

    expect(res.status).toBe(404);
  });
});

describe("unhandled errors", () => {
  it("return a generic 500 without leaking details", async () => {
    const app = createApp();
    app.get("/boom", () => {
      throw new Error("secret detail for jane@example.com");
    });

    const res = await app.request("/boom", {}, { APP_ENV: "dev" });

    expect(res.status).toBe(500);
    expect(await res.text()).toBe("Internal error");
  });
});
