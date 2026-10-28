-- Sync push and pull (ADR-0019): who can call them, and that RLS still
-- decides what they touch. Behaviour across transactions (cursors, retries,
-- two devices) is tested through the Worker in functions/test/sync.test.ts.
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
insert into public.plants (id, household_id, nickname, preset_id) values
  ('b1000000-0000-4000-8000-000000000002', 'bbbbbbbb-0000-4000-8000-00000000000b', 'Ficus', 'ficus');

grant usage on schema extensions to anon, plantnfc_api; -- test only, rolled back

create function pg_temp.act_as(p_user uuid) returns void language sql as $$
  select set_config('request.jwt.claims',
    json_build_object('sub', p_user, 'role', 'authenticated')::text, true);
$$;

-- ---------------------------------------------------------------------------
-- Who can call
-- ---------------------------------------------------------------------------
set local role anon;
select throws_ok(
  $$ select sync.pull('aaaaaaaa-0000-4000-8000-00000000000a', '0') $$,
  '42501', null, 'anon: no access to the sync schema');
reset role;

-- The Worker must switch to the user's role: as plantnfc_api it can't sync.
set local role plantnfc_api;
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
select throws_ok(
  $$ select sync.pull('aaaaaaaa-0000-4000-8000-00000000000a', '0') $$,
  '42501', null, 'plantnfc_api: no access without switching to the user');
reset role;

-- ---------------------------------------------------------------------------
-- As Ann (authenticated, RLS applies)
-- ---------------------------------------------------------------------------
set local role authenticated;
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');

select is(
  sync.push('aaaaaaaa-0000-4000-8000-00000000000a', '01000000-0000-7000-8000-000000000001', $$[
    {"change_id": "c0000000-0000-7000-8000-000000000001", "entity": "plant", "op": "upsert",
     "id": "a1000000-0000-7000-8000-000000000001", "plant": {"nickname": "Monty", "preset_id": "monstera"}},
    {"change_id": "c0000000-0000-7000-8000-000000000002", "entity": "watering_event", "op": "upsert",
     "id": "a2000000-0000-7000-8000-000000000001",
     "watering_event": {"plant_id": "a1000000-0000-7000-8000-000000000001",
                        "watered_at": "2026-10-28T08:00:00Z", "source": "scan"}}
  ]$$::jsonb),
  $$[{"change_id": "c0000000-0000-7000-8000-000000000001", "status": "applied"},
     {"change_id": "c0000000-0000-7000-8000-000000000002", "status": "applied"}]$$::jsonb,
  'push: a plant and its watering are applied');

select is(
  (select user_id from public.watering_events where id = 'a2000000-0000-7000-8000-000000000001'),
  'a0000000-0000-4000-8000-000000000001'::uuid,
  'push: the watering is logged as the caller');

select is(
  sync.push('bbbbbbbb-0000-4000-8000-00000000000b', '01000000-0000-7000-8000-000000000002', $$[
    {"change_id": "c0000000-0000-7000-8000-000000000003", "entity": "plant", "op": "delete",
     "id": "b1000000-0000-4000-8000-000000000002"}
  ]$$::jsonb),
  null::jsonb,
  'push: another household answers null (404)');

select is(
  sync.push('aaaaaaaa-0000-4000-8000-00000000000a', '01000000-0000-7000-8000-000000000003', $$[
    {"change_id": "c0000000-0000-7000-8000-000000000004", "entity": "watering_event", "op": "upsert",
     "id": "a2000000-0000-7000-8000-000000000002",
     "watering_event": {"plant_id": "b1000000-0000-4000-8000-000000000002",
                        "watered_at": "2026-10-28T08:00:00Z", "source": "scan"}}
  ]$$::jsonb) -> 0 ->> 'status',
  'rejected',
  'push: a watering can''t point at another household''s plant');

select is(
  sync.pull('bbbbbbbb-0000-4000-8000-00000000000b', '0'), null::jsonb,
  'pull: another household answers null (404)');

select is(
  jsonb_array_length(sync.pull('aaaaaaaa-0000-4000-8000-00000000000a', '0') -> 'plants'), 1,
  'pull: returns the household''s plants');

select is(
  (select count(*)::int from public.sync_changes), 3,
  'ledger: RLS shows only the caller''s household; the rejected change is recorded');

reset role;
select is(
  (select nickname from public.plants where id = 'b1000000-0000-4000-8000-000000000002'
   and deleted_at is null), 'Ficus',
  'push: the other household''s plant is untouched');

select * from finish();
rollback;
