-- The role the Worker connects as through Hyperdrive (AGENTS.md section 6,
-- ADR-0017).
--
-- It can switch to `authenticated` for a transaction, after setting the
-- verified user's claims, so RLS applies to everything done on a user's
-- behalf. It does not inherit `authenticated`'s rights: outside that switch it
-- can only read what is granted to it directly below.
--
-- No password here. Locally, supabase/seed.sql sets a local-only one; on a
-- hosted project the owner sets it (docs/environments.md).

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'plantnfc_api') then
    create role plantnfc_api login noinherit;
  end if;
end;
$$;

grant authenticated to plantnfc_api with inherit false, set true;

grant usage on schema public to plantnfc_api;

-- Server-only reads (no user context): the version policy.
grant select on public.client_versions to plantnfc_api;
-- RLS is on for every table, so the grant alone returns no rows.
create policy api_reads_versions on public.client_versions
  for select to plantnfc_api using (true);

-- The owner role may act as the Worker's role (tests, administration). Since
-- Postgres 16 a role's creator can administer it but not switch to it.
grant plantnfc_api to postgres with set true;
