# web/

Static files for the app domain. The Worker in `functions/` serves them (M1), so `apple-app-site-association` gets `Content-Type: application/json` with no redirect.

- `.well-known/apple-app-site-association`: Universal Links for `/p/*`. Replace `APPLE_TEAM_ID`.
- `.well-known/assetlinks.json`: Android App Links. It lists the SHA-256 fingerprint of every key that may sign the app:
  - The debug key on the main development machine (`%USERPROFILE%\.android\debug.keystore`, created 2026-10-23), for M1 testing. **Remove it before the production release.**
  - The upload key and the Play app signing key: add them when the app is created in Play Console.

  Fingerprints are public. Keystores and their passwords are not, and never go in the repo.

The placeholders are tracked in [ADR-0007](../docs/adr/0007-provisional-open-decisions.md).
