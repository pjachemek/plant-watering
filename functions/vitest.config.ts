import { cloudflareTest } from "@cloudflare/vitest-plugin";
import { defineConfig } from "vitest/config";

export default defineConfig({
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
