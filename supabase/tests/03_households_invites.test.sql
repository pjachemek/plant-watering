-- Household lifecycle and invites (FR-7, ADR-0018), called the way the Worker
-- calls them: as plantnfc_api with the user's verified claims set.
begin;
create extension if not exists pgtap with schema extensions;
select * from no_plan();

insert into auth.users (id, email) values
  ('a0000000-0000-4000-8000-000000000001', 'ann@example.test'),
  ('b0000000-0000-4000-8000-000000000002', 'bob@example.test'),
  ('c0000000-0000-4000-8000-000000000003', 'cat@example.test');

-- Test-only, rolled back: pgTAP lives in the extensions schema.
grant usage on schema extensions to plantnfc_api;

create function pg_temp.act_as(p_user uuid) returns void language sql as $$
  select set_config('request.jwt.claims',
    json_build_object('sub', p_user, 'role', 'authenticated')::text, true);
$$;

-- ---------------------------------------------------------------------------
-- Clients can't call the private functions.
-- ---------------------------------------------------------------------------
set local role authenticated;
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
select throws_ok(
  $$ select private.create_household(gen_random_uuid(), 'x', 'Ann') $$,
  '42501', null, 'authenticated: cannot call private functions');
reset role;
set local role anon;
select throws_ok(
  $$ select private.accept_invite(repeat('a', 64), 'x') $$,
  '42501', null, 'anon: cannot call private functions');
reset role;

-- ---------------------------------------------------------------------------
-- As the Worker
-- ---------------------------------------------------------------------------
set local role plantnfc_api;

-- No claims at all (the earlier act_as is still set in this transaction).
select set_config('request.jwt.claims', '', true);
select throws_ok(
  $$ select private.create_household(gen_random_uuid(), 'x', 'Nobody') $$,
  '42501', null, 'create_household: refused without a signed-in user');

-- Ann creates a household and is its first member.
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
select is(
  private.create_household('aaaaaaaa-0000-7000-8000-00000000000a', 'Ann home', 'Ann', 'south'),
  'aaaaaaaa-0000-7000-8000-00000000000a'::uuid,
  'create_household: returns the new id');
reset role;
select results_eq(
  $$ select h.name, h.hemisphere, m.display_name from public.households h
     join public.household_members m on m.household_id = h.id
     where h.id = 'aaaaaaaa-0000-7000-8000-00000000000a' $$,
  $$ values ('Ann home'::text, 'south'::text, 'Ann'::text) $$,
  'create_household: household and first member created together');

-- Invites (created by a member through RLS in the Worker; inserted here).
insert into public.invites (household_id, code_hash, created_by, expires_at) values
  ('aaaaaaaa-0000-7000-8000-00000000000a', repeat('1', 64),
   'a0000000-0000-4000-8000-000000000001', now() + interval '7 days'),
  ('aaaaaaaa-0000-7000-8000-00000000000a', repeat('2', 64),
   'a0000000-0000-4000-8000-000000000001', now() + interval '7 days'),
  ('aaaaaaaa-0000-7000-8000-00000000000a', repeat('3', 64),
   'a0000000-0000-4000-8000-000000000001', now() + interval '7 days');
update public.invites set expires_at = now() - interval '1 minute'
  where code_hash = repeat('3', 64);

set local role plantnfc_api;

-- Bob joins with invite 1.
select pg_temp.act_as('b0000000-0000-4000-8000-000000000002');
select is(private.accept_invite(repeat('1', 64), 'Bob'),
  'aaaaaaaa-0000-7000-8000-00000000000a'::uuid, 'accept_invite: Bob joins');

-- Invite 1 is used up; unknown and expired codes look the same.
select pg_temp.act_as('c0000000-0000-4000-8000-000000000003');
select is(private.accept_invite(repeat('1', 64), 'Cat'), null::uuid,
  'accept_invite: a used code is refused');
select is(private.accept_invite(repeat('f', 64), 'Cat'), null::uuid,
  'accept_invite: an unknown code is refused');
select is(private.accept_invite(repeat('3', 64), 'Cat'), null::uuid,
  'accept_invite: an expired code is refused');

-- An existing member doesn't use up an invite.
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
select is(private.accept_invite(repeat('2', 64), 'Ann'),
  'aaaaaaaa-0000-7000-8000-00000000000a'::uuid, 'accept_invite: existing member gets the household');
reset role;
select ok(
  (select used_at is null from public.invites where code_hash = repeat('2', 64)),
  'accept_invite: an existing member leaves the invite unused');
select results_eq(
  $$ select used_by from public.invites where code_hash = repeat('1', 64) $$,
  $$ values ('b0000000-0000-4000-8000-000000000002'::uuid) $$,
  'accept_invite: records who used the code');

set local role plantnfc_api;

-- Leaving.
select pg_temp.act_as('c0000000-0000-4000-8000-000000000003');
select is(private.leave_household('aaaaaaaa-0000-7000-8000-00000000000a', false), 'not_member',
  'leave_household: not a member');
select pg_temp.act_as('b0000000-0000-4000-8000-000000000002');
select is(private.leave_household('aaaaaaaa-0000-7000-8000-00000000000a', false), 'left',
  'leave_household: a member leaves');
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
select is(private.leave_household('aaaaaaaa-0000-7000-8000-00000000000a', false),
  'confirmation_required', 'leave_household: the last member must confirm');
select is(private.leave_household('aaaaaaaa-0000-7000-8000-00000000000a', true), 'deleted',
  'leave_household: the last member confirms and the household is deleted');
select is(private.leave_household('aaaaaaaa-0000-7000-8000-00000000000a', true), 'not_member',
  'leave_household: a deleted household can''t be left again');

reset role;
select ok(
  (select deleted_at is not null from public.households
   where id = 'aaaaaaaa-0000-7000-8000-00000000000a'),
  'leave_household: household soft-deleted');
select is_empty(
  $$ select 1 from public.invites
     where household_id = 'aaaaaaaa-0000-7000-8000-00000000000a' and deleted_at is null $$,
  'leave_household: open invites are withdrawn with the household');

select * from finish();
rollback;
