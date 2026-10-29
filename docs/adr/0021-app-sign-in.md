# ADR-0021: App sign-in with Google and email links

- Status: Accepted; email links superseded by ADR-0022
- Date: 2026-10-29
- Related: M2 increment 2.8; AGENTS.md sections 4–6, 9; ADR-0012, ADR-0016; FR-7; NFR Security (credentials), Privacy, Offline, Accessibility

## Context

FR-7 asks for sign-in with Apple, Google or an email magic link. Apple waits with iOS (ADR-0009). The app uses Supabase Auth for sign-in and token refresh only; everything else goes through the API (ADR-0012). Session tokens must sit in the Keystore (NFR Security), and a signed-in cold start from a tag must not stop at a sign-in screen (AGENTS.md section 5).

## Decision

**Supabase Auth through `gotrue` alone**, not the full `supabase_flutter` SDK. That SDK bundles the data, storage, realtime and functions clients, which the app must never use. With only the auth client, "sign-in only" holds by construction. The app does the remaining work itself:

- It saves the session on every sign-in and token refresh, and restores it at start-up.
- It routes the email link through `go_router`.

**Google: the Android account picker (Credential Manager) through `google_sign_in`.**

- The picker returns a Google ID token for the **Web** OAuth client. Supabase verifies that client id. A separate **Android** OAuth client registers the package and signing key with Google; it isn't used in code.
- **A nonce binds the token to the attempt.**
  - The app makes 32 random bytes and sends their SHA-256 to Google, which puts it in the token. It sends the raw value to Supabase, which checks the match.
  - The plugin can be set up only once per process, so one nonce serves every attempt in a process. It stays in memory only.
- **Without a Web client id**, the Google button is hidden, so a build without Google still offers email links.

**Email: a magic link with PKCE, landing on a verified App Link.**

- The link goes to `https://plants.pampait.pl/auth/callback?code=…`. Android opens it in the app because the domain's `assetlinks.json` names our signing key (as for `/p/`, ADR-0010). A custom scheme could be claimed by any other app.
- **The code works only on the phone that asked for it.** The app exchanges the code using a verifier it kept in secure storage, so a stolen link is useless.
- **In a browser** (a computer, or a phone without the app), the URL shows a static page asking to open the link on the phone. The page never reads the code.
- **Supabase's redirect allow list** must contain this URL in every project.

**Storage: `flutter_secure_storage`.**

- The session and the PKCE verifier are encrypted with a key held in the Android Keystore (NFR Security).
- If the key is lost, the store resets, and the person signs in again.
- App backup is already off, so tokens never leave the phone.

**Offline and start-up:**

- `main` restores the session from storage before the first frame, with no network. A signed-in cold start therefore opens a tag's plant directly.
- An expired access token is refreshed when the network allows. Being offline never signs anyone out. A session the server has revoked does, and the app returns to sign-in.

**Routing (`go_router` redirect):**

- **Signed out:** every screen leads to sign-in, keeping the destination in `?from=`. A tag scanned before signing in still opens its plant afterwards. `from` must be an in-app path.
- **Signed in:** the sign-in screens lead on.

**Sign-in screen:**

- It offers Google or an email link, and confirms where a link was sent.
- Each failure has a message with an icon, so it doesn't rely on colour alone, and is announced by screen readers. Closing the account picker shows nothing.
- It is checked against the accessibility guidelines, at 200% text, and with goldens in light, dark and 200%.

**Sign out** forgets the session locally first, then revokes it on the server when possible. Until the household settings screen arrives (2.10), the button sits on the home screen.

**Configuration:** the Web client id comes from `GOOGLE_WEB_CLIENT_ID` (`--dart-define`). Client ids aren't secrets, but each environment has its own, so they live in the untracked `.env`, not the code. The client secret exists only in the Supabase dashboard.

## Device findings (Pixel 9 Pro, Android 17, 2026-10-29)

Verified on the device: Google sign-in; staying signed in after the app is closed; a tag that cold-starts the app, both signed in and signed out; sign-out; and signing in again straight after signing out. Email links weren't tested, because the dev project has email turned off for now.

Two bugs were found and fixed, each with a regression test:

- **Sign-in undone by a slow sign-out.** Forgetting the Google account took about 3 s, because Android waits for every registered credential provider; here Microsoft Authenticator timed out. Sign-out waited for that step, then forced "signed out", undoing a sign-in made in the meantime.
  - Now everything sign-out must do at once happens before any slow step, and the status always follows the client's current session, never a late event.
- **The wrong screen after a tag cold start.** Android hands an app link to Flutter as the full URL. The redirect kept it whole as `from`, then refused it after sign-in as "outside the app" and opened the plant list.
  - Now `from` keeps only the path and query.

## Dependencies

| Package | Use | Licence | Publisher | Maintenance (2026-10-29) |
| --- | --- | --- | --- | --- |
| `gotrue` ^2.27.3 | Supabase Auth client | MIT | supabase.io | Released 2026-10-09; part of the official Supabase Dart SDK |
| `google_sign_in` ^7.2.0 | Google account picker | BSD-3-Clause | flutter.dev | Flutter team package; Android implementation 7.2.18 |
| `flutter_secure_storage` ^11.2.0 | Keystore-backed storage | BSD-3-Clause | steenbakker.dev | Released 2026-09-16; most-used secure storage plugin |
| `crypto` ^3.0.8 | SHA-256 of the nonce | BSD-3-Clause | dart.dev | Dart team package (already a transitive dependency) |
| `http` ^1.6.0 (dev only) | Fake auth server in tests | BSD-3-Clause | dart.dev | Dart team package (already a transitive dependency) |

None of them collects analytics or tracks users. `google_sign_in` talks only to Google's sign-in service, which the person chooses to use.

## Consequences

- **Owner setup**, per Supabase project:
  - Google OAuth clients (Web, plus one Android client per signing key: debug, upload and Play app signing);
  - the Google provider turned on in Supabase;
  - the redirect URL added to the allow list.
  - `docs/environments.md` lists the steps.
- **Before real users**, magic links need an SMTP provider in Supabase (M2 plan, prerequisite 3).
- **iOS** (when it resumes) adds Sign in with Apple, and Google on iOS.
- **Increment 2.9** builds the API client on `AuthRepository.accessToken()`. A `401` from the API will trigger one refresh and retry.
