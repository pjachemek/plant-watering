import { createRemoteJWKSet, errors, jwtVerify, type JWTPayload, type JWTVerifyGetKey } from "jose";

/** The signed-in caller, from a verified Supabase access token. */
export interface AuthUser {
  id: string;
  claims: JWTPayload;
}

export type AuthResult =
  | { ok: true; user: AuthUser }
  /** The token is missing or invalid: the app should sign in again. */
  | { ok: false; reason: "unauthorized" }
  /** The signing keys couldn't be fetched: retry later, keep the session. */
  | { ok: false; reason: "unavailable" };

/** Asymmetric only: tokens signed with the legacy shared secret are refused. */
const ALGORITHMS = ["ES256", "RS256"];

const remoteKeySets = new Map<string, JWTVerifyGetKey>();

/**
 * Supabase's published signing keys (JWKS), cached per isolate. jose re-fetches
 * when it sees an unknown key id, so key rotation works without a deploy.
 */
export function supabaseKeys(supabaseUrl: string): JWTVerifyGetKey {
  let keys = remoteKeySets.get(supabaseUrl);
  if (!keys) {
    keys = createRemoteJWKSet(new URL("/auth/v1/.well-known/jwks.json", supabaseUrl), {
      cacheMaxAge: 10 * 60 * 1000,
      cooldownDuration: 30 * 1000,
    });
    remoteKeySets.set(supabaseUrl, keys);
  }
  return keys;
}

/** Reads `Authorization: Bearer <token>`. */
export function bearerToken(header: string | undefined): string | undefined {
  const match = /^Bearer ([A-Za-z0-9._-]+)$/.exec(header ?? "");
  return match?.[1];
}

/**
 * Verifies a Supabase access token: signature against the JWKS, issuer,
 * audience `authenticated`, expiry, and `role: authenticated` (AGENTS.md
 * section 6). Never throws.
 */
export async function verifyAccessToken(
  token: string | undefined,
  keys: JWTVerifyGetKey,
  supabaseUrl: string,
): Promise<AuthResult> {
  if (!token) return { ok: false, reason: "unauthorized" };
  try {
    const { payload } = await jwtVerify(token, keys, {
      issuer: new URL("/auth/v1", supabaseUrl).toString(),
      audience: "authenticated",
      algorithms: ALGORITHMS,
    });
    if (payload.role !== "authenticated" || typeof payload.sub !== "string") {
      return { ok: false, reason: "unauthorized" };
    }
    return { ok: true, user: { id: payload.sub, claims: payload } };
  } catch (error) {
    if (error instanceof errors.JWKSTimeout || error instanceof TypeError) {
      // Network failure fetching the keys, not a bad token.
      return { ok: false, reason: "unavailable" };
    }
    return { ok: false, reason: "unauthorized" };
  }
}
