import { describe, expect, it } from "vitest";
import { operations } from "../src/api/generated/operations.gen";
import { schemaFor } from "../src/api/v1";
import { authHeaders, testApp, VERSION_HEADERS } from "./helpers";

const UUID = "0192f3c4-5a6b-7c8d-9e0f-1a2b3c4d5e6f";
const TOKEN = "AbCdEfGhIjKlMnOpQrStUv";
const call = testApp();

/** A concrete path for an operation, with valid example parameters. */
function examplePath(path: string): string {
  return path.replace("{household_id}", UUID).replace("{token}", TOKEN);
}

interface ProblemBody {
  type: string;
  status: number;
  errors?: { location: string; pointer: string; code: string }[];
}

describe("contract coverage", () => {
  it("every operation in openapi.yaml has generated header validation", () => {
    for (const op of operations) {
      expect(schemaFor(op.operationId, "header"), op.operationId).toBeDefined();
    }
  });

  it("every operation in openapi.yaml is routed (never a 404 for a valid path)", async () => {
    for (const op of operations) {
      const res = await call(examplePath(op.path), {
        method: op.method.toUpperCase(),
        headers: await authHeaders(),
        ...(op.method === "get" ? {} : { body: "{}" }),
      });

      expect(res.status, `${op.method} ${op.path}`).not.toBe(404);
    }
  });

  it("answers 501 for a valid request to an operation without a handler yet", async () => {
    const res = await call("/households", {
      method: "POST",
      headers: await authHeaders(),
      body: JSON.stringify({ name: "Home", display_name: "Ann" }),
    });

    expect(res.status).toBe(501);
    expect((await res.json<ProblemBody>()).type).toBe("not_implemented");
  });
});

describe("request validation", () => {
  it("rejects missing version headers with the header names, case as in the spec", async () => {
    const res = await call("/config");
    const body = await res.json<ProblemBody>();

    expect(res.status).toBe(400);
    expect(body.type).toBe("invalid_request");
    expect(body.errors?.map((e) => `${e.location}:${e.pointer}`).sort()).toEqual([
      "header:X-API-Version",
      "header:X-App-Version",
      "header:X-Platform",
    ]);
  });

  it("reads headers case-insensitively", async () => {
    const res = await call("/config", {
      headers: { "x-app-version": "0.1.0", "x-platform": "android", "x-api-version": "1" },
    });

    expect(res.status).toBe(200);
  });

  it("rejects an unknown platform and an unsupported API version", async () => {
    const res = await call("/config", {
      headers: { ...VERSION_HEADERS, "X-Platform": "windows-phone", "X-API-Version": "2" },
    });
    const body = await res.json<ProblemBody>();

    expect(res.status).toBe(400);
    expect(body.errors?.map((e) => e.pointer).sort()).toEqual(["X-API-Version", "X-Platform"]);
  });

  it("points at the invalid body field without echoing its value", async () => {
    const secret = "jane@example.com".padEnd(100, "x");
    const res = await call("/households", {
      method: "POST",
      headers: await authHeaders(),
      body: JSON.stringify({ name: "", display_name: secret }),
    });
    const text = await res.text();
    const body = JSON.parse(text) as ProblemBody;

    expect(res.status).toBe(400);
    expect(body.errors).toEqual([
      { location: "body", pointer: "name", code: "too_small" },
      { location: "body", pointer: "display_name", code: "too_big" },
    ]);
    expect(text).not.toContain("jane");
  });

  it("validates nested sync changes", async () => {
    const res = await call("/sync/push", {
      method: "POST",
      headers: await authHeaders({ "Idempotency-Key": UUID }),
      body: JSON.stringify({
        household_id: UUID,
        changes: [
          {
            change_id: UUID,
            entity: "plant",
            op: "upsert",
            id: UUID,
            fields: ["nickname", "interval_summer_days"],
            plant: { nickname: "Monty", interval_summer_days: 99 },
          },
        ],
      }),
    });
    const body = await res.json<ProblemBody>();

    expect(res.status).toBe(400);
    expect(body.errors?.[0]).toMatchObject({
      location: "body",
      pointer: "changes.0.plant.interval_summer_days",
    });
  });

  it("requires an Idempotency-Key on push", async () => {
    const res = await call("/sync/push", {
      method: "POST",
      headers: await authHeaders(),
      body: JSON.stringify({ household_id: UUID, changes: [] }),
    });
    const body = await res.json<ProblemBody>();

    expect(res.status).toBe(400);
    expect(body.errors?.map((e) => `${e.location}:${e.pointer}`)).toContain(
      "header:Idempotency-Key",
    );
  });

  it("rejects a malformed path parameter", async () => {
    const res = await call("/tags/short", { headers: await authHeaders() });
    const body = await res.json<ProblemBody>();

    expect(res.status).toBe(400);
    expect(body.errors?.[0]).toMatchObject({ location: "path", pointer: "token" });
  });

  it("rejects a body that is not JSON", async () => {
    const res = await call("/households", {
      method: "POST",
      headers: await authHeaders(),
      body: "{not json",
    });

    expect(res.status).toBe(400);
    expect((await res.json<ProblemBody>()).type).toBe("invalid_json");
  });

  it("returns 404 problem details for paths outside the contract", async () => {
    const res = await call("/plants", { headers: VERSION_HEADERS });

    expect(res.status).toBe(404);
    expect(res.headers.get("content-type")).toBe("application/problem+json");
  });
});
