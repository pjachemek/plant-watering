-- Data isolation and integrity (AGENTS.md sections 6 and 9: "automated tests
-- prove no cross-household access"). Runs as the signed-in user, the way the
-- Worker queries the database (ADR-0012).
begin;
create extension if not exists pgtap with schema extensions;
select * from no_plan();

-- ---------------------------------------------------------------------------
-- Fixtures (as the database owner): Ann in household A, Bob in household B.
-- ---------------------------------------------------------------------------
insert into auth.users (id, email) values
  ('a0000000-0000-4000-8000-000000000001', 'ann@example.test'),
  ('b0000000-0000-4000-8000-000000000002', 'bob@example.test');

insert into public.households (id, name) values
  ('aaaaaaaa-0000-4000-8000-00000000000a', 'Ann home'),
  ('bbbbbbbb-0000-4000-8000-00000000000b', 'Bob home');

insert into public.household_members (household_id, user_id, display_name) values
  ('aaaaaaaa-0000-4000-8000-00000000000a', 'a0000000-0000-4000-8000-000000000001', 'Ann'),
  ('bbbbbbbb-0000-4000-8000-00000000000b', 'b0000000-0000-4000-8000-000000000002', 'Bob');

insert into public.plants (id, household_id, nickname, preset_id) values
  ('a1000000-0000-4000-8000-000000000001', 'aaaaaaaa-0000-4000-8000-00000000000a', 'Monty', 'monstera'),
  ('b1000000-0000-4000-8000-000000000002', 'bbbbbbbb-0000-4000-8000-00000000000b', 'Ficus', 'ficus'),
  -- Untagged, so linking tests reach the household check, not the one-tag rule.
  ('b1000000-0000-4000-8000-000000000003', 'bbbbbbbb-0000-4000-8000-00000000000b', 'Fern', 'fern');

insert into public.tags (household_id, token, plant_id) values
  ('aaaaaaaa-0000-4000-8000-00000000000a', 'AAAAAAAAAAAAAAAAAAAAAA', 'a1000000-0000-4000-8000-000000000001'),
  ('bbbbbbbb-0000-4000-8000-00000000000b', 'BBBBBBBBBBBBBBBBBBBBBB', 'b1000000-0000-4000-8000-000000000002');

insert into public.watering_events (id, household_id, plant_id, user_id, watered_at, source) values
  ('a2000000-0000-4000-8000-000000000001', 'aaaaaaaa-0000-4000-8000-00000000000a',
   'a1000000-0000-4000-8000-000000000001', 'a0000000-0000-4000-8000-000000000001', now(), 'scan'),
  ('b2000000-0000-4000-8000-000000000002', 'bbbbbbbb-0000-4000-8000-00000000000b',
   'b1000000-0000-4000-8000-000000000002', 'b0000000-0000-4000-8000-000000000002', now(), 'list');

insert into public.invites (household_id, code_hash, created_by, expires_at) values
  ('bbbbbbbb-0000-4000-8000-00000000000b', repeat('b', 64),
   'b0000000-0000-4000-8000-000000000002', now() + interval '7 days');

insert into public.devices (user_id, platform, push_token) values
  ('b0000000-0000-4000-8000-000000000002', 'android', 'bob-token');
insert into public.notification_prefs (user_id) values
  ('a0000000-0000-4000-8000-000000000001'),
  ('b0000000-0000-4000-8000-000000000002');
insert into public.digest_sends (user_id, household_id, local_date, plant_ids, collapse_key) values
  ('a0000000-0000-4000-8000-000000000001', 'aaaaaaaa-0000-4000-8000-00000000000a',
   current_date, '{}', 'digest');

-- ---------------------------------------------------------------------------
-- Structure: RLS everywhere, every foreign key indexed (section 9).
-- ---------------------------------------------------------------------------
select is_empty(
  $$ select tablename from pg_tables where schemaname = 'public' and not rowsecurity $$,
  'RLS is enabled on every public table'
);

select is_empty(
  $$
  select c.conrelid::regclass::text || ' ' || c.conname
  from pg_constraint c
  where c.contype = 'f'
    and c.connamespace = 'public'::regnamespace
    and not exists (
      select 1 from pg_index i
      where i.indrelid = c.conrelid
        and (i.indkey::int2[])[0:cardinality(c.conkey) - 1] @> c.conkey
        and (i.indkey::int2[])[0:cardinality(c.conkey) - 1] <@ c.conkey
    )
  $$,
  'every foreign key has an index starting with its columns'
);

-- ---------------------------------------------------------------------------
-- Ann, signed in
-- ---------------------------------------------------------------------------
set local role authenticated;
select set_config('request.jwt.claims',
  '{"sub":"a0000000-0000-4000-8000-000000000001","role":"authenticated"}', true);

select ok(public.is_member('aaaaaaaa-0000-4000-8000-00000000000a'), 'is_member: own household');
select ok(not public.is_member('bbbbbbbb-0000-4000-8000-00000000000b'), 'is_member: other household');

-- Reads are limited to Ann's household.
select results_eq('select id from public.households',
  $$ values ('aaaaaaaa-0000-4000-8000-00000000000a'::uuid) $$, 'households: own only');
select results_eq('select display_name from public.household_members',
  $$ values ('Ann'::text) $$, 'members: own household only');
select results_eq('select nickname from public.plants',
  $$ values ('Monty'::text) $$, 'plants: own only');
select results_eq('select token from public.tags',
  $$ values ('AAAAAAAAAAAAAAAAAAAAAA'::text) $$, 'tags: own only');
select is_empty($$ select 1 from public.tags where token = 'BBBBBBBBBBBBBBBBBBBBBB' $$,
  'tags: another household''s token resolves to nothing (FR-1)');
select results_eq('select id from public.watering_events',
  $$ values ('a2000000-0000-4000-8000-000000000001'::uuid) $$, 'watering: own only');
select is_empty('select 1 from public.invites', 'invites: other household hidden');
select is_empty('select 1 from public.devices', 'devices: other users hidden');
select results_eq('select user_id from public.notification_prefs',
  $$ values ('a0000000-0000-4000-8000-000000000001'::uuid) $$, 'notification prefs: own only');

-- Writes into household B are rejected.
select throws_ok(
  $$ insert into public.plants (household_id, nickname, preset_id)
     values ('bbbbbbbb-0000-4000-8000-00000000000b', 'Sneaky', 'ficus') $$,
  '42501', null, 'plants: cannot create in another household');
select is_empty(
  $$ update public.plants set nickname = 'x'
     where household_id = 'bbbbbbbb-0000-4000-8000-00000000000b' returning id $$,
  'plants: cannot update another household');
select is_empty(
  $$ update public.households set name = 'x'
     where id = 'bbbbbbbb-0000-4000-8000-00000000000b' returning id $$,
  'households: cannot update another household');
select throws_ok(
  $$ insert into public.tags (household_id, token)
     values ('bbbbbbbb-0000-4000-8000-00000000000b', 'CCCCCCCCCCCCCCCCCCCCCC') $$,
  '42501', null, 'tags: cannot create in another household');
select throws_ok(
  $$ insert into public.watering_events (household_id, plant_id, user_id, watered_at, source)
     values ('bbbbbbbb-0000-4000-8000-00000000000b', 'b1000000-0000-4000-8000-000000000002',
             'a0000000-0000-4000-8000-000000000001', now(), 'scan') $$,
  '42501', null, 'watering: cannot log in another household');
select throws_ok(
  $$ insert into public.invites (household_id, code_hash, created_by, expires_at)
     values ('bbbbbbbb-0000-4000-8000-00000000000b', repeat('c', 64),
             'a0000000-0000-4000-8000-000000000001', now() + interval '1 day') $$,
  '42501', null, 'invites: cannot invite into another household');
select throws_ok(
  $$ insert into public.household_members (household_id, user_id, display_name)
     values ('bbbbbbbb-0000-4000-8000-00000000000b', 'a0000000-0000-4000-8000-000000000001', 'Ann') $$,
  '42501', null, 'members: cannot join a household directly');
select throws_ok(
  $$ insert into public.households (name) values ('Second home') $$,
  '42501', null, 'households: not created directly (server function only)');

-- Rows can't be moved into or linked across households.
select throws_ok(
  $$ update public.plants set household_id = 'bbbbbbbb-0000-4000-8000-00000000000b'
     where id = 'a1000000-0000-4000-8000-000000000001' $$,
  '42501', null, 'plants: cannot move to another household');
select throws_ok(
  $$ insert into public.tags (household_id, token, plant_id)
     values ('aaaaaaaa-0000-4000-8000-00000000000a', 'DDDDDDDDDDDDDDDDDDDDDD',
             'b1000000-0000-4000-8000-000000000003') $$,
  '23503', null, 'tags: cannot link to another household''s plant');

-- Own household works.
select lives_ok(
  $$ insert into public.plants (household_id, nickname, preset_id)
     values ('aaaaaaaa-0000-4000-8000-00000000000a', 'Basil', 'basil') $$,
  'plants: create in own household');
select lives_ok(
  $$ insert into public.watering_events (household_id, plant_id, user_id, watered_at, source)
     values ('aaaaaaaa-0000-4000-8000-00000000000a', 'a1000000-0000-4000-8000-000000000001',
             'a0000000-0000-4000-8000-000000000001', now(), 'list') $$,
  'watering: log in own household');
select throws_ok(
  $$ insert into public.watering_events (household_id, plant_id, user_id, watered_at, source)
     values ('aaaaaaaa-0000-4000-8000-00000000000a', 'a1000000-0000-4000-8000-000000000001',
             'b0000000-0000-4000-8000-000000000002', now(), 'list') $$,
  '42501', null, 'watering: cannot log on behalf of someone else');

-- Watering events are append-only, except undo.
select throws_ok(
  $$ update public.watering_events set watered_at = now() - interval '1 day'
     where id = 'a2000000-0000-4000-8000-000000000001' $$,
  '42501', null, 'watering: history cannot be rewritten');
select lives_ok(
  $$ update public.watering_events set deleted_at = now()
     where id = 'a2000000-0000-4000-8000-000000000001' $$,
  'watering: undo sets deleted_at');
select throws_ok(
  $$ update public.watering_events set deleted_at = null
     where id = 'a2000000-0000-4000-8000-000000000001' $$,
  '42501', null, 'watering: an undo cannot be reverted');

-- Server-only tables are unreachable.
select throws_ok('select 1 from public.digest_sends', '42501', null,
  'digest_sends: no client access');
select throws_ok('select 1 from public.client_versions', '42501', null,
  'client_versions: no client access');
select throws_ok('delete from public.plants', '42501', null,
  'plants: no hard deletes (soft delete only)');

-- A member who leaves loses access.
update public.household_members set deleted_at = now()
  where user_id = 'a0000000-0000-4000-8000-000000000001';
select is_empty('select 1 from public.plants', 'after leaving: no plants visible');

-- ---------------------------------------------------------------------------
-- Anonymous callers see nothing.
-- ---------------------------------------------------------------------------
reset role;
set local role anon;
select throws_ok('select 1 from public.plants', '42501', null, 'anon: no access to plants');
select throws_ok('select 1 from public.households', '42501', null, 'anon: no access to households');

-- ---------------------------------------------------------------------------
-- Integrity rules (as owner)
-- ---------------------------------------------------------------------------
reset role;
select throws_ok(
  $$ insert into public.plants (household_id, nickname)
     values ('aaaaaaaa-0000-4000-8000-00000000000a', 'Mystery') $$,
  '23514', null, 'plants: a custom plant needs its own care values');
select throws_ok(
  $$ insert into public.tags (household_id, token) values
     ('aaaaaaaa-0000-4000-8000-00000000000a', 'short') $$,
  '23514', null, 'tags: token must be 22 base62 characters');
select throws_ok(
  $$ insert into public.tags (household_id, token, plant_id) values
     ('aaaaaaaa-0000-4000-8000-00000000000a', 'EEEEEEEEEEEEEEEEEEEEEE',
      'a1000000-0000-4000-8000-000000000001') $$,
  '23505', null, 'tags: one active tag per plant');
select throws_ok(
  $$ insert into public.invites (household_id, code_hash, created_by, expires_at)
     values ('aaaaaaaa-0000-4000-8000-00000000000a', repeat('d', 64),
             'a0000000-0000-4000-8000-000000000001', now() + interval '8 days') $$,
  '23514', null, 'invites: expire within 7 days');

-- Sync cursor: every write stamps the writing transaction.
update public.plants set nickname = 'Monty II' where id = 'a1000000-0000-4000-8000-000000000001';
select is(
  (select change_xid from public.plants where id = 'a1000000-0000-4000-8000-000000000001'),
  pg_current_xact_id(),
  'sync: an update stamps change_xid with the current transaction');

-- Purging a plant unlinks its tag instead of deleting it.
delete from public.plants where id = 'b1000000-0000-4000-8000-000000000002';
select results_eq(
  $$ select plant_id from public.tags where token = 'BBBBBBBBBBBBBBBBBBBBBB' $$,
  $$ values (null::uuid) $$,
  'tags: purging a plant unlinks its tag');

-- Deleting an account keeps the household's watering history (FR-9).
delete from auth.users where id = 'a0000000-0000-4000-8000-000000000001';
select results_eq(
  $$ select user_id from public.watering_events
     where id = 'a2000000-0000-4000-8000-000000000001' $$,
  $$ values (null::uuid) $$,
  'account deletion: watering history kept, author cleared');

select * from finish();
rollback;
