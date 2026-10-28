# ADR-0015: API contract first, with generated Worker validation and Dart client

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.2; AGENTS.md sections 4, 5, 6 and 10; NFR Compatibility (two rows), Privacy (logs), Maintainability

## Context

The brief makes `functions/openapi.yaml` (OpenAPI 3.1) the source of truth for the app–backend boundary. The Worker validates every request and response against it with Zod, the Dart client is generated from it, and CI blocks breaking changes within a version. Two sides generated from one file only help if neither can quietly drift.

## Decision

**Spec first.** `functions/openapi.yaml` is written by hand and linted by Redocly with the `recommended-strict` ruleset, so warnings fail. Both sides are generated from it, and the generated code is committed.

**Worker side** (`functions/`):

- `@hey-api/openapi-ts` generates TypeScript types and Zod schemas into `src/api/generated/`.
- `scripts/generate-operations.mjs` generates the list of operations: method, Hono path, and whether auth is required.
- `src/api/v1.ts` **registers routes from that list**. Every operation exists and is validated as soon as it's in the spec. An operation without a handler answers `501 not_implemented` until its increment lands.
- Validation covers headers (read case-insensitively, spelled as in the spec), path, query and JSON body. A violation is `400 invalid_request` with `errors: [{location, pointer, code}]`. It says where, never what, so submitted values never reach responses or logs.

**App side** (`app/`):

- `swagger_parser` generates retrofit clients on Dio, with freezed and json_serializable models, into `lib/core/api/generated/`.
- **Tolerant parsing** (section 5): enums get an `$unknown` fallback, and unknown JSON fields are ignored.
- **Nulls are omitted** (`include_if_null: false` in `app/build.yaml`), because the contract treats absent and `null` differently.
- `/live` is excluded by tag: it's a WebSocket, handled separately.

**Patches name their fields.** A typed client that omits nulls can't otherwise say "clear this field". So a sync `upsert` of a household, plant or tag lists the field names it sets in `fields`. A listed field takes the value sent, or null when absent; unlisted fields don't change. This was caught by the shared fixtures before any client depended on it.

**Shared contract fixtures.** `functions/test/fixtures/contract/*.json` are validated by the Worker's Zod schemas and parsed and re-encoded by the Dart models. If either side drifts from the contract, its test fails.

**CI** (`.github/workflows/ci.yml`):

- Redocly lint.
- Both generators run, and the job fails if any generated file changed.
- **Breaking-change check:** `oasdiff breaking` (pinned image `tufin/oasdiff:v1.34.1`) compares the PR's spec with the base branch's and fails on errors. It was tested locally: a removed endpoint and a newly required field both fail; an unchanged spec passes. After the first store release, the comparison should move to the last released tag.

**Generated code** is excluded from lint and coverage: the ESLint ignore list, the Vitest coverage exclude, the Dart analyzer exclude, and the `coverage:ignore-file` header the generator writes. Hand-written code stays under the full rules.

**Endpoints added to the brief's list** (all additive, needed by the app):

- `GET /households`: find your households after a reinstall.
- `POST /households/{household_id}/leave`: FR-7, with the last-member confirmation.
- `GET /photos/download-url`: section 6 mentions signed download URLs.

`ValidationIssue` was also added to the problem details.

**Dependency override.** `@hey-api/openapi-ts` depends on `js-yaml` 4.2.0, which has three high-severity advisories (GHSA-52cp-r559-cp3m, GHSA-5p4m-2wfm-xmqj, GHSA-2883-xcg3-v3hh). It's overridden to 4.3.2, following ADR-0011's policy, and the override should be removed when the generator updates.

## Consequences

- Changing the API means editing the spec, then running `npm run generate:api` in `functions/` and `dart run swagger_parser` followed by `build_runner` in `app/`. CI enforces all three.
- Response validation (the "and response" half of the brief) is added with the first real handlers in 2.3. With only `501` stubs there's nothing to validate yet.
- `@hey-api/openapi-ts` is pre-1.0 and pinned exactly. Upgrades need a regeneration and a review of the diff.

## Dependencies added

| Package | Version | Licence | Maintenance | Why |
| --- | --- | --- | --- | --- |
| zod (Worker runtime) | 4.6.7 | MIT | Very active | Request and response validation (mandated) |
| @hey-api/openapi-ts (dev) | 0.99.0 | MIT | Active, frequent releases | Types and Zod schemas from the spec |
| @redocly/cli (dev) | 2.71.2 | MIT | Active | Spec linting |
| js-yaml, @types/js-yaml (dev) | 4.3.2, 4.0.9 | MIT | Stable | Reading the spec in the operations generator |
| oasdiff (CI, Docker image) | 1.34.1 | Apache-2.0 | Active | Breaking-change check |
| dio | ^5.11.1 | MIT | 160/160 pub points, ~8.4k likes | HTTP client under retrofit |
| retrofit, retrofit_generator (dev) | ^4.10.0, ^10.3.2 | MIT | 145–160/160, active | Typed REST clients |
| freezed, freezed_annotation | ^4.0.3, ^3.1.0 | MIT | 150–160/160, very active | Immutable models (mandated) |
| json_serializable, json_annotation | ^6.15.2, ^4.12.0 | BSD-3-Clause | Dart team | JSON models (mandated) |
| swagger_parser (dev) | ^1.45.0 | MIT | 160/160, active | Dart client generation from OpenAPI |
