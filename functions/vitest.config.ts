import { cloudflareTest } from "@cloudflare/vitest-plugin";
import { fileURLToPath } from "node:url";
import { defineConfig } from "vitest/config";

export default defineConfig({
  resolve: {
    alias: {
      // pg (CommonJS) requires pg-protocol and pg-cloudflare, which the test
      // runner would resolve to an ESM build and an empty fallback. Point both
      // at their CommonJS (workerd) builds. Tests only; the Worker bundle
      // (esbuild) resolves these correctly.
      "pg-cloudflare": fileURLToPath(
        new URL("./node_modules/pg-cloudflare/dist/index.js", import.meta.url).href,
      ),
      "pg-protocol": fileURLToPath(
        new URL("./node_modules/pg-protocol/dist/index.js", import.meta.url).href,
      ),
    },
  },
  plugins: [cloudflareTest({ wrangler: { configPath: "./wrangler.jsonc" } })],
  test: {
    // The first request loads the Worker bundle cold, which can take several seconds.
    testTimeout: 30_000,
    coverage: {
      provider: "istanbul",
      include: ["src/**/*.ts"],
      exclude: ["src/api/generated/**"],
      reporter: ["text", "lcov"],
      thresholds: { lines: 70, functions: 70, branches: 70, statements: 70 },
    },
  },
});
