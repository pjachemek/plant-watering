-- Sync push and pull (AGENTS.md section 5, ADR-0019).
--
-- Both are one database call each, so a push or pull costs one round trip
-- over Hyperdrive. They run with the caller's rights (security invoker): the
-- Worker calls them as the signed-in user (role authenticated), so every RLS
-- policy still applies. Unlike private.*, they grant nothing RLS doesn't.

create schema sync;
revoke all on schema sync from public;
grant usage on schema sync to authenticated;

-- ---------------------------------------------------------------------------
-- Change ledger: one row per change id, so a retried change is never applied
-- twice and its result is stable. Purged after 90 days (ADR-0019).
-- ---------------------------------------------------------------------------

create table public.sync_changes (
  change_id uuid primary key,
  household_id uuid not null references public.households (id) on delete cascade,
  idempotency_key uuid not null,
  status text not null check (status in ('applied', 'duplicate', 'rejected')),
  problem jsonb,
  created_at timestamptz not null default now()
);

create index sync_changes_household_id on public.sync_changes (household_id);

alter table public.sync_changes enable row level security;
grant select, insert on public.sync_changes to authenticated;
create policy members_read on public.sync_changes
  for select to authenticated using (public.is_member(household_id));
create policy members_record on public.sync_changes
  for insert to authenticated with check (public.is_member(household_id));

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- RFC 3339 in UTC with a Z, as the contract's Timestamp expects.
create function sync.iso(t timestamptz)
returns text
language sql
stable
set search_path = ''
as $$
  select to_char(t at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"');
$$;

-- A rejection the client can act on. Never carries user data.
create function sync.reject(p_type text, p_message text)
returns void
language plpgsql
set search_path = ''
as $$
begin
  raise exception '%', p_message using errcode = 'PN001', detail = p_type;
end;
$$;

-- ---------------------------------------------------------------------------
-- Applying one change
-- ---------------------------------------------------------------------------

-- Applies one validated change to the household and returns 'applied' or
-- 'duplicate'. Raises for a rejection; sync.push turns that into a result.
create function sync.apply_change(p_household uuid, c jsonb)
returns text
language plpgsql
set search_path = ''
as $$
declare
  v_entity text := c ->> 'entity';
  v_op text := c ->> 'op';
  v_id uuid := (c ->> 'id')::uuid;
  v_patch jsonb := c -> v_entity;
  v_fields jsonb;
  v_allowed text[];
  v_deleted boolean;
  v_plant uuid;
  v_token text;
  v_patches int;
begin
  -- Exactly the patch matching the entity, and only for upsert (contract).
  v_patches := (select count(*) from jsonb_object_keys(c) k
                where k in ('household', 'plant', 'tag', 'watering_event'));
  if v_patches <> (v_op = 'upsert' and jsonb_typeof(v_patch) = 'object')::int then
    perform sync.reject('invalid_change', 'The change must carry exactly the patch for its entity');
  end if;

  -- The fields this upsert sets; without a list, the keys present.
  v_allowed := case v_entity
    when 'household' then array['name', 'public_cards_enabled', 'hemisphere']
    when 'plant' then array['nickname', 'preset_id', 'preset_version', 'room', 'photo_path',
      'interval_summer_days', 'interval_winter_days', 'amount', 'method', 'notes']
    when 'tag' then array['token', 'plant_id', 'written_at']
    else array['plant_id', 'watered_at', 'source']
  end;
  if v_op = 'upsert' then
    v_fields := coalesce(c -> 'fields', (select jsonb_agg(k) from jsonb_object_keys(v_patch) k));
    if exists (select 1 from jsonb_array_elements_text(v_fields) f where f <> all (v_allowed)) then
      perform sync.reject('invalid_change', 'The change lists a field that can''t be set');
    end if;
  end if;

  -- Households: settings only; created and left through their own endpoints.
  if v_entity = 'household' then
    if v_op = 'delete' or v_id <> p_household then
      perform sync.reject('invalid_change', 'A household can only be changed, not created or deleted, through sync');
    end if;
    update public.households set
      name = case when v_fields ? 'name' then v_patch ->> 'name' else name end,
      public_cards_enabled = case when v_fields ? 'public_cards_enabled'
        then (v_patch ->> 'public_cards_enabled')::boolean else public_cards_enabled end,
      hemisphere = case when v_fields ? 'hemisphere' then v_patch ->> 'hemisphere' else hemisphere end
    where id = p_household and deleted_at is null;
    if not found then
      perform sync.reject('not_found', 'The household doesn''t exist');
    end if;
    return 'applied';
  end if;

  -- Plants: per-field last write wins, in arrival order.
  if v_entity = 'plant' then
    select deleted_at is not null into v_deleted
    from public.plants where id = v_id and household_id = p_household for update;

    if v_op = 'delete' then
      if v_deleted is null then
        perform sync.reject('not_found', 'The plant doesn''t exist');
      end if;
      if not v_deleted then
        update public.plants set deleted_at = now() where id = v_id;
        -- Its sticker becomes free to link to another plant (FR-6).
        update public.tags set plant_id = null
        where plant_id = v_id and household_id = p_household and deleted_at is null;
      end if;
      return 'applied';
    end if;

    if v_fields ? 'photo_path' and v_patch ->> 'photo_path' is not null
       and v_patch ->> 'photo_path' not like p_household::text || '/' || v_id::text || '/%' then
      perform sync.reject('invalid_change', 'The photo belongs to another plant');
    end if;

    if v_deleted then
      perform sync.reject('not_found', 'The plant was deleted');
    elsif v_deleted is null then
      insert into public.plants (id, household_id, nickname, preset_id, preset_version, room,
        photo_path, interval_summer_days, interval_winter_days, amount, method, notes)
      values (
        v_id, p_household,
        case when v_fields ? 'nickname' then v_patch ->> 'nickname' end,
        case when v_fields ? 'preset_id' then v_patch ->> 'preset_id' end,
        case when v_fields ? 'preset_version' then (v_patch ->> 'preset_version')::integer end,
        case when v_fields ? 'room' then v_patch ->> 'room' end,
        case when v_fields ? 'photo_path' then v_patch ->> 'photo_path' end,
        case when v_fields ? 'interval_summer_days' then (v_patch ->> 'interval_summer_days')::smallint end,
        case when v_fields ? 'interval_winter_days' then (v_patch ->> 'interval_winter_days')::smallint end,
        case when v_fields ? 'amount' then v_patch ->> 'amount' end,
        case when v_fields ? 'method' then v_patch ->> 'method' end,
        case when v_fields ? 'notes' then v_patch ->> 'notes' end);
    else
      update public.plants set
        nickname = case when v_fields ? 'nickname' then v_patch ->> 'nickname' else nickname end,
        preset_id = case when v_fields ? 'preset_id' then v_patch ->> 'preset_id' else preset_id end,
        preset_version = case when v_fields ? 'preset_version'
          then (v_patch ->> 'preset_version')::integer else preset_version end,
        room = case when v_fields ? 'room' then v_patch ->> 'room' else room end,
        photo_path = case when v_fields ? 'photo_path' then v_patch ->> 'photo_path' else photo_path end,
        interval_summer_days = case when v_fields ? 'interval_summer_days'
          then (v_patch ->> 'interval_summer_days')::smallint else interval_summer_days end,
        interval_winter_days = case when v_fields ? 'interval_winter_days'
          then (v_patch ->> 'interval_winter_days')::smallint else interval_winter_days end,
        amount = case when v_fields ? 'amount' then v_patch ->> 'amount' else amount end,
        method = case when v_fields ? 'method' then v_patch ->> 'method' else method end,
        notes = case when v_fields ? 'notes' then v_patch ->> 'notes' else notes end
      where id = v_id;
    end if;
    return 'applied';
  end if;

  -- Tags: the token never changes; linking a plant moves it off its old tag.
  if v_entity = 'tag' then
    select deleted_at is not null, token into v_deleted, v_token
    from public.tags where id = v_id and household_id = p_household for update;

    if v_op = 'delete' then
      if v_deleted is null then
        perform sync.reject('not_found', 'The tag doesn''t exist');
      end if;
      if not v_deleted then
        update public.tags set deleted_at = now() where id = v_id;
      end if;
      return 'applied';
    end if;

    if v_deleted then
      perform sync.reject('not_found', 'The tag was deleted');
    end if;
    if v_deleted is not null and v_fields ? 'token' and v_patch ->> 'token' is distinct from v_token then
      perform sync.reject('invalid_change', 'A tag''s token can''t change');
    end if;

    if v_fields ? 'plant_id' and v_patch ->> 'plant_id' is not null then
      v_plant := (v_patch ->> 'plant_id')::uuid;
      if not exists (select 1 from public.plants
                     where id = v_plant and household_id = p_household and deleted_at is null) then
        perform sync.reject('not_found', 'The plant doesn''t exist');
      end if;
      -- One active tag per plant: the newest link wins (FR-6, replace a tag).
      update public.tags set plant_id = null
      where plant_id = v_plant and household_id = p_household and deleted_at is null and id <> v_id;
    end if;

    if v_deleted is null then
      insert into public.tags (id, household_id, token, plant_id, written_at, written_by)
      values (
        v_id, p_household,
        case when v_fields ? 'token' then v_patch ->> 'token' end,
        v_plant,
        case when v_fields ? 'written_at' then (v_patch ->> 'written_at')::timestamptz end,
        case when v_fields ? 'written_at' and v_patch ->> 'written_at' is not null
          then (select auth.uid()) end);
    else
      update public.tags set
        plant_id = case when v_fields ? 'plant_id' then v_plant else plant_id end,
        written_at = case when v_fields ? 'written_at'
          then (v_patch ->> 'written_at')::timestamptz else written_at end,
        written_by = case when v_fields ? 'written_at'
          then case when v_patch ->> 'written_at' is not null then (select auth.uid()) end
          else written_by end
      where id = v_id;
    end if;
    return 'applied';
  end if;

  -- Watering events: append-only and idempotent by id; delete is the undo.
  if v_op = 'delete' then
    update public.watering_events set deleted_at = now()
    where id = v_id and household_id = p_household and deleted_at is null;
    if not found and not exists (select 1 from public.watering_events
                                 where id = v_id and household_id = p_household) then
      perform sync.reject('not_found', 'The watering doesn''t exist');
    end if;
    return 'applied';
  end if;

  v_plant := (v_patch ->> 'plant_id')::uuid;
  if not exists (select 1 from public.plants
                 where id = v_plant and household_id = p_household and deleted_at is null) then
    perform sync.reject('not_found', 'The plant doesn''t exist');
  end if;
  insert into public.watering_events (id, household_id, plant_id, user_id, watered_at, source)
  values (
    v_id, p_household, v_plant, (select auth.uid()),
    -- A phone with its clock ahead can't log a watering in the future.
    least((v_patch ->> 'watered_at')::timestamptz, now()),
    v_patch ->> 'source')
  on conflict (id) do nothing;
  if found then
    return 'applied';
  end if;
  if exists (select 1 from public.watering_events where id = v_id and household_id = p_household) then
    return 'duplicate';
  end if;
  perform sync.reject('conflict', 'The id is already in use');
  return null; -- not reached
end;
$$;

-- ---------------------------------------------------------------------------
-- Push and pull
-- ---------------------------------------------------------------------------

-- Applies the changes in order and returns one result per change, or null
-- when the caller isn't a member. A change id seen before keeps its result:
-- the original one under the same Idempotency-Key, 'duplicate' otherwise.
create function sync.push(p_household uuid, p_idempotency_key uuid, p_changes jsonb)
returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_change jsonb;
  v_change_id uuid;
  v_prior record;
  v_status text;
  v_problem jsonb;
  v_results jsonb := '[]';
begin
  if not public.is_member(p_household) then
    return null;
  end if;

  for v_change in select value from jsonb_array_elements(p_changes) loop
    v_change_id := (v_change ->> 'change_id')::uuid;
    select s.status, s.problem, s.idempotency_key into v_prior
    from public.sync_changes s where s.change_id = v_change_id;

    if found then
      if v_prior.idempotency_key = p_idempotency_key or v_prior.status = 'rejected' then
        v_status := v_prior.status;
        v_problem := v_prior.problem;
      else
        v_status := 'duplicate';
        v_problem := null;
      end if;
    else
      v_problem := null;
      begin
        v_status := sync.apply_change(p_household, v_change);
      exception
        when sqlstate 'PN001' then
          declare
            v_type text;
            v_title text;
          begin
            get stacked diagnostics v_type = pg_exception_detail, v_title = message_text;
            v_status := 'rejected';
            v_problem := jsonb_build_object('type', v_type, 'title', v_title, 'status',
              case v_type when 'not_found' then 404 when 'conflict' then 409 else 422 end);
          end;
        when foreign_key_violation then
          v_status := 'rejected';
          v_problem := jsonb_build_object('type', 'not_found',
            'title', 'A row it refers to doesn''t exist', 'status', 404);
        when unique_violation then
          v_status := 'rejected';
          v_problem := jsonb_build_object('type', 'conflict',
            'title', 'The change conflicts with existing data', 'status', 409);
        when not_null_violation or check_violation or insufficient_privilege
             or invalid_text_representation or invalid_datetime_format
             or datetime_field_overflow or numeric_value_out_of_range then
          v_status := 'rejected';
          v_problem := jsonb_build_object('type', 'invalid_change',
            'title', 'The change breaks a data rule', 'status', 422);
      end;
      -- Anything else (a lost connection, a bug) fails the whole push, so the
      -- client retries instead of losing the change.
      insert into public.sync_changes (change_id, household_id, idempotency_key, status, problem)
      values (v_change_id, p_household, p_idempotency_key, v_status, v_problem)
      on conflict (change_id) do nothing;
    end if;

    v_results := v_results || jsonb_build_array(
      jsonb_build_object('change_id', v_change_id, 'status', v_status)
      || case when v_problem is null then '{}'::jsonb else jsonb_build_object('problem', v_problem) end);
  end loop;

  return v_results;
end;
$$;

-- Everything in the household written at or after the cursor, soft deletes
-- included, and the next cursor. One statement, so the rows and the cursor
-- come from the same snapshot (ADR-0014). Null when the caller isn't a member.
create function sync.pull(p_household uuid, p_cursor xid8)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select jsonb_build_object(
    'cursor', pg_snapshot_xmin(pg_current_snapshot())::text,
    'household', jsonb_build_object(
      'id', h.id, 'name', h.name, 'public_cards_enabled', h.public_cards_enabled,
      'hemisphere', h.hemisphere, 'created_at', sync.iso(h.created_at),
      'updated_at', sync.iso(h.updated_at), 'deleted_at', sync.iso(h.deleted_at)),
    'members', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', m.id, 'household_id', m.household_id, 'user_id', m.user_id,
        'display_name', m.display_name, 'joined_at', sync.iso(m.joined_at),
        'updated_at', sync.iso(m.updated_at), 'deleted_at', sync.iso(m.deleted_at)))
      from public.household_members m
      where m.household_id = h.id and m.change_xid >= p_cursor), '[]'::jsonb),
    'plants', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', p.id, 'household_id', p.household_id, 'nickname', p.nickname,
        'preset_id', p.preset_id, 'preset_version', p.preset_version, 'room', p.room,
        'photo_path', p.photo_path, 'interval_summer_days', p.interval_summer_days,
        'interval_winter_days', p.interval_winter_days, 'amount', p.amount,
        'method', p.method, 'notes', p.notes, 'created_at', sync.iso(p.created_at),
        'updated_at', sync.iso(p.updated_at), 'deleted_at', sync.iso(p.deleted_at)))
      from public.plants p
      where p.household_id = h.id and p.change_xid >= p_cursor), '[]'::jsonb),
    'tags', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', t.id, 'household_id', t.household_id, 'token', t.token,
        'plant_id', t.plant_id, 'written_at', sync.iso(t.written_at),
        'written_by', t.written_by, 'updated_at', sync.iso(t.updated_at),
        'deleted_at', sync.iso(t.deleted_at)))
      from public.tags t
      where t.household_id = h.id and t.change_xid >= p_cursor), '[]'::jsonb),
    'watering_events', coalesce((
      select jsonb_agg(jsonb_build_object(
        'id', w.id, 'household_id', w.household_id, 'plant_id', w.plant_id,
        'user_id', w.user_id, 'watered_at', sync.iso(w.watered_at), 'source', w.source,
        'created_at', sync.iso(w.created_at), 'deleted_at', sync.iso(w.deleted_at)))
      from public.watering_events w
      where w.household_id = h.id and w.change_xid >= p_cursor), '[]'::jsonb))
  from public.households h
  where h.id = p_household and public.is_member(h.id);
$$;

-- Only signed-in users, through the Worker; RLS decides what they touch.
revoke all on all functions in schema sync from public;
grant execute on all functions in schema sync to authenticated;
