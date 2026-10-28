-- The Worker's database role (ADR-0017): only what it needs, and RLS applies
-- whenever it acts for a user.
begin;
create extension if not exists pgtap with schema extensions;
select * from no_plan();

insert into auth.users (id, email) values
  ('a0000000-0000-4000-8000-000000000001', 'ann@example.test'),
  ('b0000000-0000-4000-8000-000000000002', 'bob@example.test');
insert into public.households (id, name) values
  ('aaaaaaaa-0000-4000-8000-00000000000a', 'Ann home'),
  ('bbbbbbbb-0000-4000-8000-00000000000b', 'Bob home');
insert into public.household_members (household_id, user_id, display_name) values
  ('aaaaaaaa-0000-4000-8000-00000000000a', 'a0000000-0000-4000-8000-000000000001', 'Ann'),
  ('bbbbbbbb-0000-4000-8000-00000000000b', 'b0000000-0000-4000-8000-000000000002', 'Bob');

select ok(
  (select rolcanlogin and not rolinherit and not rolsuper and not rolbypassrls
   from pg_roles where rolname = 'plantnfc_api'),
  'plantnfc_api: can log in, no inheritance, not superuser, no RLS bypass');

select ok(not pg_has_role('plantnfc_api', 'service_role', 'member'),
  'plantnfc_api: not a member of service_role');
select ok(not pg_has_role('plantnfc_api', 'postgres', 'member'),
  'plantnfc_api: not a member of postgres');

-- Test-only, rolled back: pgTAP lives in the extensions schema.
grant usage on schema extensions to plantnfc_api;

-- As the Worker, with no user context.
set local role plantnfc_api;

select results_eq(
  $$ select platform from public.client_versions order by platform $$,
  $$ values ('android'::text), ('ios'::text) $$,
  'plantnfc_api: reads the version policy directly');
select throws_ok('select 1 from public.plants', '42501', null,
  'plantnfc_api: no direct access to household data');
select throws_ok('select 1 from public.households', '42501', null,
  'plantnfc_api: no direct access to households');
-- SET ROLE is checked against the login user, which is postgres in this
-- session, so "cannot become service_role" is tested by the Worker's
-- integration tests, which log in as plantnfc_api (functions/test/db.test.ts).

-- Acting for Ann, the way the Worker does it in one statement.
select set_config('request.jwt.claims',
  '{"sub":"a0000000-0000-4000-8000-000000000001","role":"authenticated"}', true),
  set_config('role', 'authenticated', true);

select results_eq(
  $$ select name from public.households $$,
  $$ values ('Ann home'::text) $$,
  'acting for a user: RLS limits households to theirs');
select throws_ok('select 1 from public.client_versions', '42501', null,
  'acting for a user: server-only tables are out of reach');

select * from finish();
rollback;
