import {
  envVersionPolicy,
  type Platform,
  type VersionPolicy,
  type VersionPolicySource,
} from "../api/versions";
import { rows, withDb } from "./client";

/**
 * The version policy from the `client_versions` table (FR-10), so the minimum
 * version changes without a deploy. Cached per isolate for [ttlMs]. If the
 * database can't be read, the Worker variables are used instead: a database
 * outage must not block the update check (ADR-0017).
 */
export function createDbVersionPolicy(ttlMs = 60_000): VersionPolicySource {
  const cache = new Map<Platform, { at: number; policy: VersionPolicy }>();

  return async (platform, env) => {
    const hit = cache.get(platform);
    if (hit && Date.now() - hit.at < ttlMs) return hit.policy;
    try {
      const [policy] = await withDb(env, (db) =>
        rows<VersionPolicy>(
          db,
          "select min_version, recommended_version from public.client_versions where platform = $1",
          [platform],
        ),
      );
      if (!policy) return await envVersionPolicy(platform, env);
      const value = {
        min_version: policy.min_version,
        recommended_version: policy.recommended_version,
      };
      cache.set(platform, { at: Date.now(), policy: value });
      return value;
    } catch (error) {
      console.error("version_policy_fallback", error instanceof Error ? error.name : "unknown");
      return envVersionPolicy(platform, env);
    }
  };
}
