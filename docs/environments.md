# Environments

How the Worker, Supabase and the app line up. None of these values are secret; keys, passwords and connection strings never go in the repo.

| Environment | Worker (`wrangler.jsonc`) | API host | Supabase project | Used for |
| --- | --- | --- | --- | --- |
| Local | top level (`npm run dev`) | `api.localhost:8787` | Local CLI stack (`npm run db:start`) | Day-to-day development and tests |
| Development | `development` (`npm run deploy:development`) | `api-dev.plants.pampait.pl` | `utqhpnnkbiafgpnsliuz` (dev) | Real phones before staging exists (M2 device tests) |
| Staging | `staging` | `api.staging.plants.pampait.pl` (not deployed yet) | Not created yet | Internal builds from `main` (AGENTS.md section 10) |
| Production | `production` (`npm run deploy:production`) | `api.plants.pampait.pl`; web on `plants.pampait.pl` | Not created yet | Store builds |

The web host (`plants.pampait.pl`: app-link files, tag pages) is served by production only, because tag stickers always point there.

## Supabase dev project

- URL: `https://utqhpnnkbiafgpnsliuz.supabase.co`
- Signing key: asymmetric ES256 (checked 2026-10-28; the Worker refuses HS256).
- Issuer the Worker expects: `https://utqhpnnkbiafgpnsliuz.supabase.co/auth/v1`
- Hyperdrive: `plant-nfc-dev` (`63de0c5bfe174cada9afa12c669d4f43`), user `plantnfc_api.utqhpnnkbiafgpnsliuz` via the shared session pooler `aws-0-eu-west-1.pooler.supabase.com:5432` (IPv4; the direct host is IPv6-only). Bound in the `development` environment.
- Data API: **off** (turned off by the product owner on 2026-10-28), matching `supabase/config.toml` (ADR-0012). Hosted projects don't take `config.toml`, so each new project needs it turned off in the dashboard under Project Settings → Data API.

## Sign-in setup (product owner, once per project)

App sign-in uses external providers only: Google now, Apple with iOS (ADR-0021, ADR-0022). Client ids are public; client secrets stay in the Supabase dashboard.

1. **Google Cloud** (one project, e.g. "Plant NFC"):
   - **Google Auth Platform:** External audience, publishing status **Testing**, the household's Google accounts as test users. No extra scopes.
   - **Web client:** redirect URI `https://<project-ref>.supabase.co/auth/v1/callback`.
   - **Android client** for each signing key: package `pl.pampait.plantnfc` and the key's SHA-1. That means the debug key now, then the upload and Play app signing keys.
2. **Supabase → Authentication → Sign In / Providers → Google:** enable; set Client IDs to the Web client id and the Client Secret; leave nonce checks on.
3. **Supabase → Authentication → Sign In / Providers → Email:** turned **off**. Without it nobody can sign up with an email and password through the public Auth API either.
4. **App build:** `GOOGLE_WEB_CLIENT_ID=<web client id>` in `.env` (see `.env.example`).

Dev project values:

| Item | Value |
| --- | --- |
| Debug key SHA-1 | `34:82:57:8F:30:1A:DD:B7:A3:44:75:23:BC:62:8B:BA:F7:E6:2F:2E` |
| Web client id | `720190702365-3lcvrnkro5r6ghme7t4eeojfqr8g12tk.apps.googleusercontent.com` |
| Android client id (debug key) | `720190702365-a9pa1s1uclvd5130j8mme9398ls8etqq.apps.googleusercontent.com` |

## Applying the schema (product owner, once per project)

Needs the database password; run it yourself so it never leaves your machine:

```sh
npx supabase login
npx supabase link --project-ref utqhpnnkbiafgpnsliuz
npx supabase db push        # applies supabase/migrations
```

## Hyperdrive (product owner, once per project)

The Worker connects as the dedicated role `plantnfc_api`, never `postgres` (ADR-0017). Its migration comes with `supabase db push` above. Then:

1. **Generate a password** and keep it in your password manager:
   ```sh
   openssl rand -base64 32 | tr -d '/+='
   ```
2. **Set it on the role** with psql's `\password`, which prompts for it and sends only a hash, so it never appears in a query, the dashboard's SQL history or your shell history. Use the `postgres` connection string from the dashboard (Connect → Session pooler):
   ```sh
   docker run -it --rm postgres:17 psql "<postgres connection string>"
   ```
   ```
   \password plantnfc_api
   \q
   ```
3. **Create the Hyperdrive configuration.** Use the same Session pooler host and port, with the user changed to `plantnfc_api.utqhpnnkbiafgpnsliuz` (Supabase's pooler wants `<role>.<project-ref>`) and the new password. Check Cloudflare's Hyperdrive guide for Supabase in case it now recommends a different connection type.
   ```sh
   cd functions
   npx wrangler hyperdrive create plant-nfc-dev --connection-string="postgres://plantnfc_api.utqhpnnkbiafgpnsliuz:<password>@<pooler host>:5432/postgres"
   ```
   The connection string, including the password, stays in Cloudflare. This command line contains the password, so keep it out of shell history: in Git Bash, start the line with a space (works when `HISTCONTROL` includes `ignorespace`), or delete the entry afterwards (PowerShell keeps history in `(Get-PSReadLineOption).HistorySavePath`).
4. **Send only the Hyperdrive id** it prints. It goes into the `development` environment in `wrangler.jsonc`.
