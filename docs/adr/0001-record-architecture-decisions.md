# ADR-0001: Record architecture decisions

- Status: Accepted
- Date: 2026-10-23

## Context

AGENTS.md section 10 requires an ADR for every significant decision, and section 12 says to record choices made where the brief is silent. Several agents may work on the repo, so decisions need to live in the repo, not in chat history.

## Decision

- ADRs live in `docs/adr/`, numbered `NNNN-kebab-title.md`, using [0000-template.md](0000-template.md).
- An ADR is immutable once accepted. A changed decision gets a new ADR that supersedes the old one, and the old one's status is updated.
- Every new dependency is listed in an ADR with version, licence, maintenance status and reason (AGENTS.md section 4).
- Decisions that depend on an open product-owner question are marked **Provisional** and listed in [ADR-0007](0007-provisional-open-decisions.md).

## Consequences

Reviewers can check a PR against the ADRs it cites. Small decisions may be grouped in one ADR per area to keep the log readable.
