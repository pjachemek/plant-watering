import { env, exports } from "cloudflare:workers";
import { describe, expect, it } from "vitest";
import { createApp } from "../src/app";

// In tests the Worker runs with the dev vars, so the API host is api.localhost.
const API = "http://api.localhost";
const WEB = "https://plants.pampait.pl";
const TOKEN = "AbCdEfGhIjKlMnOpQrStUv";

describe("API host", () => {
  it("serves health as JSON", async () => {
    const res = await exports.default.fetch(`${API}/health`);

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ status: "ok", env: "dev" });
  });

  it("answers unknown paths with RFC 9457 problem details", async () => {
    const res = await exports.default.fetch(`${API}/v1/nope`);

    expect(res.status).toBe(404);
    expect(res.headers.get("content-type")).toBe("application/problem+json");
    expect(res.headers.get("cache-control")).toBe("no-store");
    expect(await res.json()).toEqual({ type: "not_found", title: "Not found", status: 404 });
  });

  it("does not serve web pages or app-link files", async () => {
    for (const path of [`/p/${TOKEN}`, "/.well-known/assetlinks.json"]) {
      const res = await exports.default.fetch(`${API}${path}`);

      expect(res.status, path).toBe(404);
      expect(res.headers.get("content-type"), path).toBe("application/problem+json");
    }
  });

  it("sets the same security headers as the web host", async () => {
    const res = await exports.default.fetch(`${API}/health`);

    expect(res.headers.get("strict-transport-security")).toContain("max-age=");
    expect(res.headers.get("x-content-type-options")).toBe("nosniff");
  });

  it("matches the host case-insensitively", async () => {
    const res = await exports.default.fetch("http://API.LOCALHOST/v1/nope");

    expect(res.headers.get("content-type")).toBe("application/problem+json");
  });

  it("returns a problem 500 without leaking details", async () => {
    const { api } = createApp();
    api.get("/v1/boom", () => {
      throw new Error("secret detail for jane@example.com");
    });

    const res = await api.request("/v1/boom", {}, env);
    const body = await res.text();

    expect(res.status).toBe(500);
    expect(res.headers.get("content-type")).toBe("application/problem+json");
    expect(body).not.toContain("jane");
    expect(JSON.parse(body)).toEqual({
      type: "internal_error",
      title: "Internal error",
      status: 500,
    });
  });
});

describe("web host", () => {
  it("does not expose the API", async () => {
    const res = await exports.default.fetch(`${WEB}/v1/nope`);

    expect(res.status).toBe(404);
    expect(res.headers.get("content-type")).toMatch(/^text\/plain/);
  });
});
