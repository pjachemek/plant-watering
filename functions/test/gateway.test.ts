import { generateKeyPair, SignJWT } from "jose";
import { describe, expect, it } from "vitest";
import { compareVersions } from "../src/api/versions";
import { respond } from "../src/api/v1";
import { authHeaders, testApp, token, VERSION_HEADERS } from "./helpers";

interface ProblemBody {
  type: string;
  status: number;
}

const call = testApp();
const listHouseholds = async (authorization?: string, headers = VERSION_HEADERS) =>
  call("/account/export", {
    headers: authorization ? { ...headers, Authorization: authorization } : headers,
  });

describe("sign-in (Supabase JWT, AGENTS.md section 6)", () => {
  it("lets a valid token through", async () => {
    const res = await listHouseholds(`Bearer ${await token()}`);

    // Past the gateway: the operation itself is not implemented yet.
    expect(res.status).toBe(501);
  });

  it("rejects a missing token with 401 and WWW-Authenticate", async () => {
    const res = await listHouseholds();

    expect(res.status).toBe(401);
    expect(res.headers.get("www-authenticate")).toContain("Bearer");
    expect((await res.json<ProblemBody>()).type).toBe("unauthorized");
  });

  it.each([
    ["an expired token", () => token({}, { expiresIn: "-1m" })],
    ["the wrong issuer", () => token({ iss: "https://evil.example/auth/v1" })],
    ["the wrong audience", () => token({ aud: "service" })],
    ["an anonymous role", () => token({ role: "anon" })],
    ["an unknown signing key", () => token({}, { kid: "rotated-away" })],
  ])("rejects %s", async (_label, makeToken) => {
    const res = await listHouseholds(`Bearer ${await makeToken()}`);

    expect(res.status).toBe(401);
  });

  it("rejects a token signed by a different key with the same key id", async () => {
    const { privateKey } = await generateKeyPair("ES256");
    const res = await listHouseholds(`Bearer ${await token({}, { key: privateKey })}`);

    expect(res.status).toBe(401);
  });

  it("rejects legacy shared-secret (HS256) tokens", async () => {
    const hs256 = await new SignJWT({ role: "authenticated", sub: "x" })
      .setProtectedHeader({ alg: "HS256", kid: "test-key" })
      .setAudience("authenticated")
      .setExpirationTime("5m")
      .sign(new TextEncoder().encode("super-secret-jwt-token-with-at-least-32-chars"));
    const res = await listHouseholds(`Bearer ${hs256}`);

    expect(res.status).toBe(401);
  });

  it("rejects a malformed Authorization header", async () => {
    expect((await listHouseholds("Basic dXNlcjpwYXNz")).status).toBe(401);
    expect((await listHouseholds("Bearer not a token")).status).toBe(401);
  });

  it("answers 503, not 401, when the signing keys can't be fetched", async () => {
    const offline = testApp({
      signingKeys: () => () => Promise.reject(new TypeError("fetch failed")),
    });
    const res = await offline("/account/export", {
      headers: { ...VERSION_HEADERS, Authorization: `Bearer ${await token()}` },
    });

    expect(res.status).toBe(503);
    expect(res.headers.get("retry-after")).toBe("5");
    expect((await res.json<ProblemBody>()).type).toBe("auth_unavailable");
  });
});

describe("version enforcement (FR-10)", () => {
  const strict = testApp({
    versionPolicy: () => Promise.resolve({ min_version: "2.0.0", recommended_version: "2.1.0" }),
  });

  it("answers 426 below the minimum, before checking sign-in", async () => {
    const res = await strict("/households", {
      headers: { ...VERSION_HEADERS, "X-App-Version": "1.9.9" },
    });

    expect(res.status).toBe(426);
    expect((await res.json<ProblemBody>()).type).toBe("upgrade_required");
  });

  it("lets the minimum version through", async () => {
    const res = await strict("/account/export", {
      headers: await authHeaders({ "X-App-Version": "2.0.0" }),
    });

    expect(res.status).toBe(501);
  });

  it("compares versions numerically, not as text", () => {
    expect(compareVersions("0.10.0", "0.9.0")).toBeGreaterThan(0);
    expect(compareVersions("1.2.3", "1.2.3")).toBe(0);
    expect(compareVersions("1.2.3", "1.10.0")).toBeLessThan(0);
  });
});

describe("GET /v1/config", () => {
  it("returns the version policy for the calling platform without sign-in", async () => {
    const res = await call("/config", { headers: { ...VERSION_HEADERS, "X-Platform": "ios" } });

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({
      platform: "ios",
      min_version: "0.1.0",
      recommended_version: "0.1.0",
      api_version: "1",
      features: {},
    });
    expect(res.headers.get("cache-control")).toBe("public, max-age=300");
    expect(res.headers.get("vary")).toBe("X-Platform");
  });

  it("still answers 426 to unsupported versions so the app can show the update screen", async () => {
    const res = await call("/config", {
      headers: { ...VERSION_HEADERS, "X-App-Version": "0.0.1" },
    });

    expect(res.status).toBe(426);
  });
});

describe("rate limits (AGENTS.md section 6)", () => {
  const blocked = { limit: () => Promise.resolve({ success: false }) };

  it("limits public endpoints per IP", async () => {
    const res = await testApp({}, { IP_RATE_LIMITER: blocked })("/config", {
      headers: VERSION_HEADERS,
    });

    expect(res.status).toBe(429);
    expect(res.headers.get("retry-after")).toBe("60");
    expect((await res.json<ProblemBody>()).type).toBe("rate_limited");
  });

  it("limits signed-in endpoints per user, keyed by user id", async () => {
    const keys: string[] = [];
    const recording = {
      limit: ({ key }: { key: string }) => {
        keys.push(key);
        return Promise.resolve({ success: false });
      },
    };
    const res = await testApp({}, { USER_RATE_LIMITER: recording })("/account/export", {
      headers: await authHeaders(),
    });

    expect(res.status).toBe(429);
    expect(keys).toEqual(["u:0192f3c4-5a6b-7c8d-9e0f-1a2b3c4d5e71"]);
  });
});

describe("response validation", () => {
  it("never sends a response that breaks the contract", async () => {
    const broken = testApp({
      handlers: { getConfig: (c) => respond(c, { platform: "android", min_version: "x" }) },
    });
    const res = await broken("/config", { headers: VERSION_HEADERS });

    expect(res.status).toBe(500);
    expect((await res.json<ProblemBody>()).type).toBe("invalid_response");
  });
});
