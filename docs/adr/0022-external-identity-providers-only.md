# ADR-0022: Sign-in through external identity providers only

- Status: Accepted
- Date: 2026-10-29
- Decided by: product owner
- Related: FR-7; ADR-0021 (supersedes its email-link parts); AGENTS.md sections 3 and 12; NFR Security, Privacy

## Context

FR-7 listed three ways to sign up: Sign in with Apple, Google, and an email magic link. ADR-0021 built Google and email links. The product owner decided not to use or run email sign-in.

## Decision

Sign-in uses external identity providers only:

- **Google** on Android, now.
- **Sign in with Apple** on iOS, when iOS resumes (ADR-0009).

There is no email magic link and no password. Supabase's Email provider is turned off in every project, so the public Auth API won't create accounts by email either.

## What changed

**Removed:**
- **App:**
  - the email form and its strings;
  - the `/auth/callback` route and screen;
  - the App Link filter for `/auth/callback`;
  - the PKCE verifier storage;
  - the failures that only email had (`invalidEmail`, `linkInvalid`).
- **Worker:** the browser page at `/auth/callback`.
- **Setup:** the Supabase redirect URL step.

**Kept:**
- the secure session storage, the offline restore, the router guard and the nonce-bound Google sign-in (ADR-0021);
- `providerDisabled` → "Sign-in isn't set up", for a provider turned off on the server.

**New:** a build without any provider (no Google client id) says on the sign-in screen that sign-in isn't set up, instead of showing an empty screen.

## Consequences

- **Fewer moving parts:**
  - no email deliverability or SMTP provider to run (that prerequisite in the M2 plan is dropped);
  - no link-forwarding risk;
  - no browser page that receives one-time codes.
- **Who can join:** every household member needs a Google account on Android, or an Apple ID on iOS. Nearly every Android phone already has a Google account. Someone without one can't join until another provider is added; that would need a new ADR.
- **Account recovery** relies on the provider: losing access to the Google account means losing access to Plant NFC. Household data stays with the other members.
- **NFR Privacy is unchanged:** Supabase still stores the email address the provider returns, as before. It's never shown to other members or logged.
- **More providers later** (for example Microsoft) would go through the same `AuthRepository` and sign-in screen, as one more button and one more `GoogleIdTokenSource`-style platform service each.
