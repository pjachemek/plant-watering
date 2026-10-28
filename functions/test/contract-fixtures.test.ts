import { describe, expect, it } from "vitest";
import { zPullResponse, zPushRequest } from "../src/api/generated/zod.gen";
import pullResponse from "./fixtures/contract/pull_response.json";
import pushRequest from "./fixtures/contract/push_request.json";

// The same fixtures are parsed and re-encoded by the app's generated Dart
// client (app/test/core/api/contract_fixtures_test.dart). If the Worker and
// the app ever disagree about the contract, one side fails (ADR-0015).
describe("shared contract fixtures", () => {
  it("push_request.json is a valid PushRequest", () => {
    expect(zPushRequest.safeParse(pushRequest).success).toBe(true);
  });

  it("pull_response.json is a valid PullResponse", () => {
    expect(zPullResponse.safeParse(pullResponse).success).toBe(true);
  });

  it("rejects null for an optional patch (clients must omit it)", () => {
    const [first] = pushRequest.changes;
    const withNull = { ...pushRequest, changes: [{ ...first, household: null }] };

    expect(zPushRequest.safeParse(withNull).success).toBe(false);
  });
});
