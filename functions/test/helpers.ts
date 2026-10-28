import { env } from "cloudflare:workers";
import { createLocalJWKSet, exportJWK, generateKeyPair, SignJWT, type JWTPayload } from "jose";
import { createApp } from "../src/app";
import type { V1Options } from "../src/api/v1";
import type { Bindings } from "../src/env";

// The Worker runs with the dev vars in tests, so the API host is api.localhost.
export const API = "http://api.localhost/v1";
export const VERSION_HEADERS = {
  "X-App-Version": "0.1.0",
  "X-Platform": "android",
  "X-API-Version": "1",
};
export const USER_ID = "0192f3c4-5a6b-7c8d-9e0f-1a2b3c4d5e71";
const ISSUER = new URL("/auth/v1", env.SUPABASE_URL).toString();

/** An ES256 key pair standing in for the Supabase project's signing key. */
const { privateKey, publicKey } = await generateKeyPair("ES256");
const publicJwk = { ...(await exportJWK(publicKey)), kid: "test-key", alg: "ES256" };
const localKeys = createLocalJWKSet({ keys: [publicJwk] });

/** Signs an access token like Supabase does; override any claim or header. */
export async function token(
  claims: JWTPayload = {},
  options: { expiresIn?: string; key?: CryptoKey; kid?: string } = {},
): Promise<string> {
  // Defaults first, so a test can override any claim (issuer, audience...).
  const payload = {
    role: "authenticated",
    sub: USER_ID,
    iss: ISSUER,
    aud: "authenticated",
    ...claims,
  };
  return new SignJWT(payload)
    .setProtectedHeader({ alg: "ES256", kid: options.kid ?? "test-key" })
    .setIssuedAt()
    .setExpirationTime(options.expiresIn ?? "5m")
    .sign(options.key ?? privateKey);
}

/** The app with the local signing key; other options can be overridden. */
export function testApp(
  options: V1Options = {},
  bindings: Partial<Bindings> = {},
  base: Bindings = env,
) {
  const app = createApp({ signingKeys: () => localKeys, ...options });
  return (path: string, init: RequestInit = {}) =>
    app.fetch(new Request(`${API}${path}`, init), { ...base, ...bindings });
}

/** The test environment without the database binding. */
export function envWithoutDatabase(): Bindings {
  return Object.fromEntries(
    Object.entries(env).filter(([key]) => key !== "HYPERDRIVE"),
  ) as unknown as Bindings;
}

/** Headers for a signed-in, up-to-date Android app. */
export async function authHeaders(extra: Record<string, string> = {}) {
  return {
    ...VERSION_HEADERS,
    Authorization: `Bearer ${await token()}`,
    "Content-Type": "application/json",
    ...extra,
  };
}

/** Calls the API as [user] (an auth.users id) and parses the JSON reply. */
export function callerAs(call: ReturnType<typeof testApp> = testApp()) {
  return async (
    user: string,
    method: string,
    path: string,
    body?: unknown,
    headers: Record<string, string> = {},
  ) => {
    const res = await call(path, {
      method,
      headers: {
        ...VERSION_HEADERS,
        Authorization: `Bearer ${await token({ sub: user })}`,
        "Content-Type": "application/json",
        ...headers,
      },
      ...(body === undefined ? {} : { body: JSON.stringify(body) }),
    });
    const text = await res.text();
    return { status: res.status, body: (text ? JSON.parse(text) : {}) as Record<string, unknown> };
  };
}
