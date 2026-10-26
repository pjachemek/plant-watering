-- Smoke test so CI proves the pgTAP pipeline runs. RLS tests arrive with the
-- schema in M2 (AGENTS.md section 6).
begin;
create extension if not exists pgtap with schema extensions;
select plan(1);

select ok(
  current_setting('server_version_num')::int >= 170000,
  'Postgres 17 or newer'
);

select * from finish();
rollback;
