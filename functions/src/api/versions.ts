import type { Bindings } from "../env";

export type Platform = "android" | "ios";

/** Minimum and recommended app versions for one platform (FR-10). */
export interface VersionPolicy {
  min_version: string;
  recommended_version: string;
}

export type VersionPolicySource = (platform: Platform, env: Bindings) => Promise<VersionPolicy>;

/**
 * Interim source: Worker variables, the same for every platform. M2.4 replaces
 * it with the client_versions table, so the minimum version can change
 * without a deploy (NFR Compatibility).
 */
export const envVersionPolicy: VersionPolicySource = (_platform, env) =>
  Promise.resolve({
    min_version: env.MIN_APP_VERSION,
    recommended_version: env.RECOMMENDED_APP_VERSION,
  });

/** Compares two `major.minor.patch` versions: negative, zero or positive. */
export function compareVersions(a: string, b: string): number {
  const pa = a.split(".").map(Number);
  const pb = b.split(".").map(Number);
  for (let i = 0; i < 3; i++) {
    const diff = (pa[i] ?? 0) - (pb[i] ?? 0);
    if (diff !== 0) return diff;
  }
  return 0;
}
