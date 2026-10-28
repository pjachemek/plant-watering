import { defineConfig } from "@hey-api/openapi-ts";

/**
 * Generates TypeScript types and Zod schemas from the API contract
 * (openapi.yaml, ADR-0015). Run `npm run generate:api` after editing the
 * spec; CI fails if the generated files are out of date.
 */
export default defineConfig({
  input: "./openapi.yaml",
  output: {
    path: "./src/api/generated",
    postProcess: ["prettier"],
  },
  plugins: ["@hey-api/typescript", "zod"],
});
