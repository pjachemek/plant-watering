-- Sticker tokens are unique among active tags only, and are freed as soon as
-- their tag or household is deleted (ADR-0027).
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

grant usage on schema extensions to plantnfc_api; -- test only, rolled back

create function pg_temp.act_as(p_user uuid) returns void language sql as $$
  select set_config('request.jwt.claims',
    json_build_object('sub', p_user, 'role', 'authenticated')::text, true);
$$;

-- Ann links a sticker.
set local role authenticated;
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
insert into public.tags (id, household_id, token) values
  ('a3000000-0000-4000-8000-000000000001', 'aaaaaaaa-0000-4000-8000-00000000000a',
   'StickerToken0000000001');

-- While it is active, nobody else can link it.
select pg_temp.act_as('b0000000-0000-4000-8000-000000000002');
select throws_ok(
  $$ insert into public.tags (id, household_id, token) values
     ('b3000000-0000-4000-8000-000000000001', 'bbbbbbbb-0000-4000-8000-00000000000b',
      'StickerToken0000000001') $$,
  '23505', null, 'an active token is still unique');

-- Ann deletes the tag: the sticker is free at once, the row stays as history.
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
update public.tags set deleted_at = now() where id = 'a3000000-0000-4000-8000-000000000001';

select pg_temp.act_as('b0000000-0000-4000-8000-000000000002');
select lives_ok(
  $$ insert into public.tags (id, household_id, token) values
     ('b3000000-0000-4000-8000-000000000001', 'bbbbbbbb-0000-4000-8000-00000000000b',
      'StickerToken0000000001') $$,
  'a deleted tag frees its token for another household at once');

-- The same household can link a sticker again after deleting its tag.
select pg_temp.act_as('b0000000-0000-4000-8000-000000000002');
update public.tags set deleted_at = now() where id = 'b3000000-0000-4000-8000-000000000001';
select lives_ok(
  $$ insert into public.tags (id, household_id, token) values
     ('b3000000-0000-4000-8000-000000000002', 'bbbbbbbb-0000-4000-8000-00000000000b',
      'StickerToken0000000001') $$,
  'the same household can link the sticker again');
reset role;

select is(
  (select count(*)::int from public.tags where token = 'StickerToken0000000001'), 3,
  'deleted tags stay as history');

-- Deleting a household (the last member leaves) frees all its stickers.
set local role plantnfc_api;
select pg_temp.act_as('b0000000-0000-4000-8000-000000000002');
select is(private.leave_household('bbbbbbbb-0000-4000-8000-00000000000b', true), 'deleted',
  'the last member deletes the household');
reset role;

select is_empty(
  $$ select 1 from public.tags
     where household_id = 'bbbbbbbb-0000-4000-8000-00000000000b' and deleted_at is null $$,
  'deleting a household deletes its tags');

set local role authenticated;
select pg_temp.act_as('a0000000-0000-4000-8000-000000000001');
select lives_ok(
  $$ insert into public.tags (id, household_id, token) values
     ('a3000000-0000-4000-8000-000000000002', 'aaaaaaaa-0000-4000-8000-00000000000a',
      'StickerToken0000000001') $$,
  'a deleted household''s sticker can be linked elsewhere at once');
reset role;

select * from finish();
rollback;
