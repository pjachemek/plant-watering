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
- Data API: must be **off** for clients, as in `supabase/config.toml` (ADR-0012). Turn it off in the dashboard under Project Settings → Data API; hosted projects don't take `config.toml`.

## Applying the schema (product owner, once per project)

Needs the database password; run it yourself so it never leaves your machine:

```sh
npx supabase login
npx supabase link --project-ref utqhpnnkbiafgpnsliuz
npx supabase db push        # applies supabase/migrations
```

## Hyperdrive (M2.4, not yet)

The Worker will reach Postgres through Cloudflare Hyperdrive as a **dedicated, limited database role**, never `postgres` (AGENTS.md section 6). M2.4 adds the migration that creates that role. Once it's applied, you set the role's password and create the Hyperdrive configuration yourself, so the password never leaves your machine. The exact commands come with M2.4, following Cloudflare's Supabase guide for Hyperdrive. You then send only the Hyperdrive **id**, and the binding goes into `wrangler.jsonc`.
