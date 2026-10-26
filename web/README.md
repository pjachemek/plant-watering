# web/

Source files for the app domain. The Worker in `functions/` imports and serves them with `Content-Type: application/json` and no redirect (`functions/src/routes/well-known.ts`).

- `.well-known/apple-app-site-association.json`: Universal Links for `/p/*`, served at `/.well-known/apple-app-site-association` (no extension, as Apple requires). Replace `APPLE_TEAM_ID` when iOS resumes (ADR-0009).
- `.well-known/assetlinks.json`: Android App Links. It lists the SHA-256 fingerprint of every key that may sign the app:
  - The debug key on the main development machine (`%USERPROFILE%\.android\debug.keystore`, created 2026-10-23), for M1 testing. **Remove it before the production release.**
  - The upload key and the Play app signing key: add them when the app is created in Play Console.

  Fingerprints are public. Keystores and their passwords are not, and never go in the repo.

The placeholders are tracked in [ADR-0007](../docs/adr/0007-provisional-open-decisions.md).
