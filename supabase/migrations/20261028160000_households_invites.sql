-- Household lifecycle and invites (FR-7, ADR-0018).
--
-- These operations can't be expressed as row policies (a new household has no
-- members yet; an invitee isn't a member yet), so they are security definer
-- functions in a private schema. Only the Worker's role may call them, and it
-- calls them with the verified user's claims set, so auth.uid() is the caller.
-- Clients (anon, authenticated) can't reach them.

create schema private;
revoke all on schema private from public, anon, authenticated;
grant usage on schema private to plantnfc_api;

-- ---------------------------------------------------------------------------
-- create_household: the caller becomes the first member.
-- ---------------------------------------------------------------------------
create function private.create_household(
  p_id uuid,
  p_name text,
  p_display_name text,
  p_hemisphere text default 'north'
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
begin
  if v_user is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;
  insert into public.households (id, name, hemisphere)
  values (p_id, p_name, coalesce(p_hemisphere, 'north'));
  insert into public.household_members (household_id, user_id, display_name)
  values (p_id, v_user, p_display_name);
  return p_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- accept_invite: redeem a single-use, unexpired invite by its code hash.
-- Returns the household id, or null for unknown, used or expired codes
-- (indistinguishable on purpose). An existing member doesn't use it up.
-- ---------------------------------------------------------------------------
create function private.accept_invite(p_code_hash text, p_display_name text)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_invite public.invites%rowtype;
begin
  if v_user is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  select * into v_invite
  from public.invites
  where code_hash = p_code_hash
    and used_at is null
    and deleted_at is null
    and expires_at > now()
  for update;

  if not found then
    return null;
  end if;

  if exists (
    select 1 from public.household_members
    where household_id = v_invite.household_id and user_id = v_user and deleted_at is null
  ) then
    return v_invite.household_id;
  end if;

  insert into public.household_members (household_id, user_id, display_name)
  values (v_invite.household_id, v_user, p_display_name);

  update public.invites
  set used_at = now(), used_by = v_user
  where id = v_invite.id;

  return v_invite.household_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- leave_household: 'left', 'deleted', 'not_member' or
-- 'confirmation_required' (the last member must confirm; FR-7).
-- ---------------------------------------------------------------------------
create function private.leave_household(p_household uuid, p_confirm_delete boolean)
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
    return 'deleted';
  end if;
  return 'left';
end;
$$;

revoke all on all functions in schema private from public, anon, authenticated;
grant execute on function private.create_household(uuid, text, text, text) to plantnfc_api;
grant execute on function private.accept_invite(text, text) to plantnfc_api;
grant execute on function private.leave_household(uuid, boolean) to plantnfc_api;
