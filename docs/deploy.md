# Deploying the Worker (Cloudflare)

One Worker in `functions/` serves two hosts (ADR-0012):

- `plants.pampait.pl`: the App Links file, the iOS association file (for later) and the `/p/{token}` page. M1 needs it live before App Links can verify on real phones.
- `api.plants.pampait.pl`: the versioned API under `/v1`. It answers `/health` now; the endpoints arrive in M2.

## One-time setup (product owner)

1. **Cloudflare account** with the `pampait.pl` zone, meaning the domain's nameservers point to Cloudflare. If `pampait.pl` uses other DNS, you can add it to Cloudflare as a zone, or set up only the subdomain (Cloudflare limits subdomain-only setups to paid plans; check their current plan list). Moving the whole zone to Cloudflare is free.
2. **Log in** from `functions/`:
   ```sh
   npx wrangler login
   ```
3. **Deploy** the production environment. `wrangler.jsonc` declares both hosts as custom domains, so Cloudflare creates their DNS records and TLS certificates on deploy (the API host is added on the first deploy after this change):
   ```sh
   cd functions
   npm ci
   npm run deploy:production
   ```
4. **Check:**
   ```sh
   curl -i https://plants.pampait.pl/.well-known/assetlinks.json
   curl -i https://plants.pampait.pl/health
   curl -i https://api.plants.pampait.pl/health
   curl -i https://api.plants.pampait.pl/v1/anything   # 404, application/problem+json
   ```
   The first must return `200` with `content-type: application/json` and no redirect. You can also use Google's checker: `https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://plants.pampait.pl&relation=delegate_permission/common.handle_all_urls`

Secrets such as `SENTRY_DSN` are optional for M1. When needed: `npx wrangler secret put SENTRY_DSN --env production`.

## Changing the signing fingerprints

Edit `web/.well-known/assetlinks.json`, run the Worker tests (`npm test` in `functions/`; they check the fingerprint format) and deploy again. Android re-verifies App Links when the app is installed or updated; to force it on a test phone: `adb shell pm verify-app-links --re-verify pl.pampait.plantnfc`.
