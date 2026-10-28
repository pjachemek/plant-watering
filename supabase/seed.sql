-- Local development seed data. Never put real user data here (AGENTS.md section 12).

-- Local only: the password the local Worker uses through Hyperdrive
-- (functions/wrangler.jsonc, localConnectionString). Hosted projects set a
-- real one by hand (docs/environments.md).
alter role plantnfc_api with password 'local-dev-only';
