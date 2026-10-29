-- Sticker tokens are freed as soon as their tag is deleted (ADR-0027).
--
-- A token used to be unique across every tag row, deleted ones included, so
-- a deleted tag held its sticker's token until the 30-day purge. Now it is
-- unique only among active tags: a sticker can be linked again at once, in
-- the same household or another, while the deleted row stays as history.

alter table public.tags drop constraint tags_token_key;

-- Also serves token lookups (scan, public card): only active tags count.
create unique index tags_active_token on public.tags (token) where deleted_at is null;

-- Deleting a household (its last member leaving) also deletes its tags, so
-- its stickers are free at once. Same function as in
-- 20261028160000_households_invites.sql, plus that one statement.
create or replace function private.leave_household(p_household uuid, p_confirm_delete boolean)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_others integer;
begin
  if v_user is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  -- Lock the household so two members can't both leave as "not the last".
  perform 1 from public.households
  where id = p_household and deleted_at is null
  for update;
  if not found then
    return 'not_member';
  end if;

  if not exists (
    select 1 from public.household_members
    where household_id = p_household and user_id = v_user and deleted_at is null
  ) then
    return 'not_member';
  end if;

  select count(*) into v_others
  from public.household_members
  where household_id = p_household and user_id <> v_user and deleted_at is null;

  if v_others = 0 and not p_confirm_delete then
    return 'confirmation_required';
  end if;

  update public.household_members
  set deleted_at = now()
  where household_id = p_household and user_id = v_user and deleted_at is null;

  if v_others = 0 then
    -- Soft delete; purged with its rows after 30 days (AGENTS.md section 5).
    update public.households set deleted_at = now() where id = p_household;
    update public.invites set deleted_at = now()
    where household_id = p_household and deleted_at is null;
    -- Frees the household's sticker tokens at once (ADR-0027).
    update public.tags set deleted_at = now()
    where household_id = p_household and deleted_at is null;
    return 'deleted';
  end if;
  return 'left';
end;
$$;

-- create or replace keeps the existing grants (plantnfc_api only); restate
-- them so this file reads on its own.
revoke all on function private.leave_household(uuid, boolean) from public, anon, authenticated;
grant execute on function private.leave_household(uuid, boolean) to plantnfc_api;
