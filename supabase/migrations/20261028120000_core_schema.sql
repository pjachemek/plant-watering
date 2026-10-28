-- Core schema for M2 (AGENTS.md section 8; ADR-0012, ADR-0014).
--
-- Clients never reach these tables directly: the Data API is disabled and the
-- Worker queries Postgres as the signed-in user, so RLS applies as defence in
-- depth. Every synced row carries change_xid, the transaction that last wrote
-- it, which drives the sync cursor (ADR-0014).

-- ---------------------------------------------------------------------------
-- Shared triggers
-- ---------------------------------------------------------------------------

-- Keeps created_at fixed and stamps updated_at and change_xid on every write.
create function public.touch_row()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  new.change_xid := pg_current_xact_id();
  if tg_op = 'UPDATE' then
    new.created_at := old.created_at;
  end if;
  return new;
end;
$$;

-- A row never moves to another household.
create function public.keep_household_id()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.household_id is distinct from old.household_id then
    raise exception 'household_id cannot change' using errcode = '42501';
  end if;
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

create table public.households (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 80),
  -- Off by default: the household opts in to public cards (ADR-0007).
  public_cards_enabled boolean not null default false,
  hemisphere text not null default 'north' check (hemisphere in ('north', 'south')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id()
);

create table public.household_members (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 60),
  joined_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id()
);

create table public.invites (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  -- SHA-256 of the invite code, hex encoded. The code itself is never stored.
  code_hash text not null unique check (code_hash ~ '^[0-9a-f]{64}$'),
  created_by uuid not null references auth.users (id) on delete cascade,
  expires_at timestamptz not null,
  used_at timestamptz,
  used_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id(),
  -- Invites expire within 7 days (FR-7).
  check (expires_at <= created_at + interval '7 days')
);

create table public.plants (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  nickname text not null check (char_length(nickname) between 1 and 60),
  preset_id text check (preset_id ~ '^[a-z0-9-]{1,64}$'),
  -- The preset version the plant was created from (section 8).
  preset_version integer check (preset_version > 0),
  room text check (char_length(room) <= 40),
  photo_path text check (char_length(photo_path) <= 255),
  -- Overrides: null means "use the preset".
  interval_summer_days smallint check (interval_summer_days between 1 and 60),
  interval_winter_days smallint check (interval_winter_days between 1 and 60),
  amount text check (amount in ('small', 'medium', 'large')),
  method text check (method in ('top', 'bottom', 'soak', 'mist')),
  notes text check (char_length(notes) <= 500),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id(),
  -- A custom plant (no preset) must carry its own care values (FR-3).
  check (
    preset_id is not null
    or (
      interval_summer_days is not null
      and interval_winter_days is not null
      and amount is not null
      and method is not null
    )
  ),
  -- Target for composite foreign keys that keep children in the same household.
  unique (id, household_id)
);

create table public.tags (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  -- Same format as the app's TagToken: 22 base62 characters (section 7).
  token text not null unique check (token ~ '^[0-9A-Za-z]{22}$'),
  plant_id uuid,
  written_at timestamptz,
  written_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id(),
  -- A tag can only point at a plant in its own household. Purging a plant
  -- unlinks its tag instead of deleting it.
  foreign key (plant_id, household_id) references public.plants (id, household_id)
    on delete set null (plant_id)
);

create table public.watering_events (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  plant_id uuid not null,
  -- Kept as null after account deletion so household history survives.
  user_id uuid references auth.users (id) on delete set null,
  watered_at timestamptz not null,
  source text not null check (source in ('scan', 'list', 'bulk')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id(),
  foreign key (plant_id, household_id) references public.plants (id, household_id) on delete cascade
);

create table public.devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  platform text not null check (platform in ('android', 'ios')),
  push_token text check (char_length(push_token) <= 4096),
  app_version text check (char_length(app_version) <= 32),
  last_seen_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  change_xid xid8 not null default pg_current_xact_id()
);

create table public.notification_prefs (
  user_id uuid primary key references auth.users (id) on delete cascade,
  digest_time time not null default '08:00',
  -- IANA zone, for server-sent digests (ADR-0013).
  time_zone text not null default 'UTC' check (char_length(time_zone) between 1 and 64),
  enabled boolean not null default true,
  muted_plant_ids uuid[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  change_xid xid8 not null default pg_current_xact_id()
);

-- Server-only: which digest each user got, so it can be replaced in place.
create table public.digest_sends (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  household_id uuid not null references public.households (id) on delete cascade,
  local_date date not null,
  sent_at timestamptz not null default now(),
  plant_ids uuid[] not null,
  collapse_key text not null check (char_length(collapse_key) <= 64),
  unique (user_id, local_date)
);

-- Server-only: version enforcement (FR-10, section 6). Changed without an
-- app release.
create table public.client_versions (
  platform text primary key check (platform in ('android', 'ios')),
  min_version text not null check (min_version ~ '^\d+\.\d+\.\d+$'),
  recommended_version text not null check (recommended_version ~ '^\d+\.\d+\.\d+$'),
  updated_at timestamptz not null default now()
);

insert into public.client_versions (platform, min_version, recommended_version)
values ('android', '0.1.0', '0.1.0'), ('ios', '0.1.0', '0.1.0');

-- ---------------------------------------------------------------------------
-- Indexes: every foreign key, the sync cursor and watered_at (section 9).
-- ---------------------------------------------------------------------------

create unique index household_members_active_member
  on public.household_members (household_id, user_id) where deleted_at is null;
create index household_members_user_id on public.household_members (user_id);
create index household_members_sync on public.household_members (household_id, change_xid);

create index invites_household_id on public.invites (household_id);
create index invites_created_by on public.invites (created_by);
create index invites_used_by on public.invites (used_by);

create index plants_sync on public.plants (household_id, change_xid);

create index tags_household_id_sync on public.tags (household_id, change_xid);
create index tags_plant on public.tags (plant_id, household_id);
create index tags_written_by on public.tags (written_by);
-- One active tag per plant (section 8).
create unique index tags_one_active_per_plant
  on public.tags (plant_id) where deleted_at is null and plant_id is not null;

create index watering_events_sync on public.watering_events (household_id, change_xid);
create index watering_events_plant_watered_at
  on public.watering_events (plant_id, household_id, watered_at desc);
create index watering_events_user_id on public.watering_events (user_id);

create index devices_user_id on public.devices (user_id);
create unique index devices_active_push_token
  on public.devices (push_token) where push_token is not null and deleted_at is null;

create index digest_sends_household_id on public.digest_sends (household_id);

create index households_sync on public.households (change_xid);

-- ---------------------------------------------------------------------------
-- Triggers
-- ---------------------------------------------------------------------------

create trigger touch before insert or update on public.households
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.household_members
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.invites
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.plants
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.tags
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.watering_events
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.devices
  for each row execute function public.touch_row();
create trigger touch before insert or update on public.notification_prefs
  for each row execute function public.touch_row();

create trigger keep_household before update on public.household_members
  for each row execute function public.keep_household_id();
create trigger keep_household before update on public.invites
  for each row execute function public.keep_household_id();
create trigger keep_household before update on public.plants
  for each row execute function public.keep_household_id();
create trigger keep_household before update on public.tags
  for each row execute function public.keep_household_id();
create trigger keep_household before update on public.watering_events
  for each row execute function public.keep_household_id();

-- Watering events are append-only (section 5). Allowed changes: setting
-- deleted_at (undo reaches other devices this way) and clearing user_id when
-- the account is deleted (FR-9).
create function public.watering_events_append_only()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if (new.plant_id, new.watered_at, new.source, new.created_at)
     is distinct from (old.plant_id, old.watered_at, old.source, old.created_at)
     or (new.user_id is not null and new.user_id is distinct from old.user_id)
     or (old.deleted_at is not null and new.deleted_at is distinct from old.deleted_at) then
    raise exception 'watering events are append-only' using errcode = '42501';
  end if;
  return new;
end;
$$;

create trigger append_only before update on public.watering_events
  for each row execute function public.watering_events_append_only();

-- ---------------------------------------------------------------------------
-- Access control (section 6): RLS on every table, default deny.
-- ---------------------------------------------------------------------------

-- True when the signed-in user is an active member of the household.
create function public.is_member(target_household uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.household_members m
    where m.household_id = target_household
      and m.user_id = (select auth.uid())
      and m.deleted_at is null
  );
$$;

revoke all on function public.is_member(uuid) from public, anon;
grant execute on function public.is_member(uuid) to authenticated;
revoke all on function public.touch_row() from public, anon, authenticated;
revoke all on function public.keep_household_id() from public, anon, authenticated;
revoke all on function public.watering_events_append_only() from public, anon, authenticated;

alter table public.households enable row level security;
alter table public.household_members enable row level security;
alter table public.invites enable row level security;
alter table public.plants enable row level security;
alter table public.tags enable row level security;
alter table public.watering_events enable row level security;
alter table public.devices enable row level security;
alter table public.notification_prefs enable row level security;
alter table public.digest_sends enable row level security;
alter table public.client_versions enable row level security;

-- Nothing is reachable without an explicit grant below.
revoke all on all tables in schema public from anon, authenticated;

-- Households: created through a server function (increment 2.5), never
-- inserted directly, because a new household has no members yet.
grant select, update on public.households to authenticated;
create policy members_read on public.households
  for select to authenticated using (public.is_member(id));
create policy members_update on public.households
  for update to authenticated using (public.is_member(id)) with check (public.is_member(id));

-- Members: joining happens through invite redemption (2.5). A member can
-- change their own row (display name, leaving).
grant select, update on public.household_members to authenticated;
create policy members_read on public.household_members
  for select to authenticated using (public.is_member(household_id));
create policy own_row_update on public.household_members
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

-- Invites: members create them; redemption is a server function (2.5).
grant select, insert on public.invites to authenticated;
create policy members_read on public.invites
  for select to authenticated using (public.is_member(household_id));
create policy members_create on public.invites
  for insert to authenticated
  with check (public.is_member(household_id) and created_by = (select auth.uid()));

-- Plants and tags: any member reads and writes (equal rights in MVP).
-- Deletes are soft (deleted_at), so no delete grant.
grant select, insert, update on public.plants to authenticated;
create policy members_read on public.plants
  for select to authenticated using (public.is_member(household_id));
create policy members_create on public.plants
  for insert to authenticated with check (public.is_member(household_id));
create policy members_update on public.plants
  for update to authenticated
  using (public.is_member(household_id)) with check (public.is_member(household_id));

grant select, insert, update on public.tags to authenticated;
create policy members_read on public.tags
  for select to authenticated using (public.is_member(household_id));
create policy members_create on public.tags
  for insert to authenticated with check (public.is_member(household_id));
create policy members_update on public.tags
  for update to authenticated
  using (public.is_member(household_id)) with check (public.is_member(household_id));

-- Watering events: members log their own; any member may undo (deleted_at).
grant select, insert, update on public.watering_events to authenticated;
create policy members_read on public.watering_events
  for select to authenticated using (public.is_member(household_id));
create policy members_log_own on public.watering_events
  for insert to authenticated
  with check (public.is_member(household_id) and user_id = (select auth.uid()));
create policy members_undo on public.watering_events
  for update to authenticated
  using (public.is_member(household_id)) with check (public.is_member(household_id));

-- Devices and notification preferences belong to one user.
grant select, insert, update on public.devices to authenticated;
create policy own_rows on public.devices
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

grant select, insert, update on public.notification_prefs to authenticated;
create policy own_rows on public.notification_prefs
  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- digest_sends and client_versions: no grants, no policies. Only server-side
-- code reads them (increments 2.3 and M5).
