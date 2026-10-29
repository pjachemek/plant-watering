# ADR-0027: Sticker tokens are freed as soon as their tag is deleted

- Status: Accepted
- Date: 2026-10-29
- Decided by: product owner (freeing tokens); pre-written stickers left open
- Related: AGENTS.md sections 7 and 8; ADR-0014, ADR-0018, ADR-0019, ADR-0024; FR-1, FR-6

## Context

A tag token used to be unique across **every** tag row, deleted ones included (ADR-0014). Deletes are soft and purged after 30 days, so:

- a deleted tag kept its sticker's token for 30 days;
- deleting a household left its tags untouched, so its stickers' tokens stayed reserved;
- until the purge exists, every token stayed reserved for good.

That's harmless while the app writes a new token every time a sticker is written (AGENTS.md section 7). It isn't, though, if a sticker's token ever can't change, for example stickers sold pre-written and locked, an idea the product owner raised. Even with rewritable stickers, a deleted tag shouldn't block its sticker.

## Decision

**A token is unique among active tags only:** a partial unique index, `tags_active_token on tags (token) where deleted_at is null`, replaces the old constraint.

- Deleting a tag frees its sticker at once, for the same household or another. The deleted row stays as history until the purge.
- An active token is still unique. Linking it elsewhere is refused (`409 conflict`, ADR-0019) without revealing where.
- The index also serves token lookups (scan, and later the public card), which only ever look at active tags.

**Deleting a household also deletes its tags** (`private.leave_household`, when the last member confirms), so all its stickers are free at once. Plants and waterings stay untouched under the household tombstone until the purge removes it with all its rows by cascade.

**The phone follows the same rule:**
- The local index is partial in the same way (`@TableIndex.sql`). Schema v1 hadn't been released, so it was changed in place and re-exported.
- On pull, a local tag holding a token is dropped only when it is active and the incoming tag is active too. A deleted row and an active one with the same token now coexist, which is what happens when a sticker is linked again.

**Pre-written stickers are not adopted.** AGENTS.md section 7 stays as it is: the app writes the link, and stickers aren't locked in MVP. This change keeps that option open without committing to it.

## Consequences

- **Migration** `20261029120000_free_tag_tokens.sql`: run `npx supabase db push` on each hosted project. It's an expand-only change: older app versions keep working.
- **Tests:**
  - pgTAP (`05_tag_tokens`): an active token stays unique; a deleted tag frees its token for another household and for its own; deleted rows remain; deleting a household deletes its tags and frees its tokens.
  - A Worker sync test links a token freed by another household's delete.
  - An app sync test links a sticker again on one phone and checks that both phones keep the deleted and the active tag.
- **The public card (M6)** must look up active tags only, and treat a deleted household's tags as unknown. The index already enforces the first.
