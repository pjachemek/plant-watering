# ADR-0018: Households and invites through private database functions

- Status: Accepted
- Date: 2026-10-28
- Related: M2 increment 2.5; AGENTS.md sections 3 (FR-7), 6 and 8; ADR-0014, ADR-0017; NFR Security (data isolation, public endpoints)

## Context

FR-7 needs four operations: create a household, invite someone, accept an invite, and leave. A plain user write under RLS can't do some of them:

- A new household has no members yet, so `is_member()` can't allow the first membership row.
- Someone accepting an invite isn't a member yet, so they can't read the invite or add themselves.
- The last member leaving must delete the household, and two members leaving at once must not both count as "the last one".

## Decision

**Private functions for steps RLS can't express** (migration `20261028160000_households_invites.sql`):

- The functions sit in schema `private`. They are `security definer` with a fixed `search_path`, and only `plantnfc_api` can execute them. `anon` and `authenticated` can't, and tests check this.
- Each function takes the user from the verified claims (`auth.uid()`) and refuses to run without a user. A caller can never pass in another user's id.
- **`create_household(id, name, display_name, hemisphere)`** creates the household and its first member in one statement.
- **`accept_invite(code_hash, display_name)`** locks the invite and checks that it is unused and unexpired. It then adds the member and records `used_at` and `used_by`. Unknown, used and expired codes all return null. An existing member gets the household back without using up the code.
- **`leave_household(id, confirm)`** locks the household row, so concurrent leaves happen one after the other. It returns `left`, `confirmation_required`, `deleted` or `not_member`. Deleting soft-deletes the household and withdraws its open invites; the 30-day purge removes the rest (AGENTS.md section 5).

**Two ways to run a query in the Worker** (`src/db/client.ts`):

- **`asUser`** sets the claims and switches to `authenticated`, so RLS decides. Everything that RLS can express uses it, including reading households and creating invites. A refused invite insert (42501) answers 404, exactly like a household the caller can't see.
- **`asCaller`** sets the claims but stays `plantnfc_api`. Only calls to the private functions use it, because `authenticated` can't execute them.

**Invite codes:**

- 12 base62 characters from `crypto.getRandomValues`, with rejection sampling: about 71 bits.
- A code is single use, expires in 7 days and is rate-limited per user. Guessing one is not practical, and 128 bits (as for tags) would make it awkward to type.
- Only the SHA-256 of the code is stored (AGENTS.md section 8). The code is returned once, when the invite is created. A plain hash is enough, because the code is random and long, not a password.
- The link is `https://plants.pampait.pl/i/{code}`. The App Link filter for `/i/` and a web page for people without the app follow in increment 2.10. Until then, the code can be typed in.

**Ids:** the Worker creates household ids as UUID v7 (`src/lib/ids.ts`), as it does for every synced row.

## Consequences

- Business rules that need elevated rights sit in a few small functions. Tests cover each outcome (`supabase/tests/03_households_invites.test.sql`), and Worker tests run each FR-7 flow end to end against the local database (`functions/test/households.test.ts`).
- Every refusal looks the same from outside: 404 for households you aren't in and for invite codes that are unknown, used or expired.
- A deleted household stays visible to the database for up to 30 days before the purge, but never through the API.
- Until 2.10, opening an invite link on a phone shows the website's 404 page, not the app.
