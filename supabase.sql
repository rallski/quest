-- Einmal im Supabase SQL Editor ausführen.
-- Eine Zeile pro Konto mit dem kompletten App-Stand als JSON.

create table if not exists public.quest_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  state      jsonb  not null,
  updated_at bigint not null default 0
);

alter table public.quest_state enable row level security;

-- Zugriff über die Data API nur für angemeldete Konten (die Regeln unten begrenzen auf die eigene Zeile).
revoke all on public.quest_state from anon;
grant select, insert, update, delete on public.quest_state to authenticated;
revoke truncate, references, trigger on public.quest_state from authenticated;

-- Speichergrenze pro Konto: Standard 2 MB, Ausnahmen in quest_limits (die App zeigt die Nutzung in den Einstellungen).
create table if not exists public.quest_limits (
  user_id   uuid primary key references auth.users(id) on delete cascade,
  max_bytes integer not null
);
alter table public.quest_limits enable row level security;
revoke all on public.quest_limits from anon, authenticated;
grant select on public.quest_limits to authenticated;
drop policy if exists "eigene Grenze lesen" on public.quest_limits;
create policy "eigene Grenze lesen" on public.quest_limits for select to authenticated using (auth.uid() = user_id);
-- Beispiel: eigenes Konto auf 20 MB
-- insert into public.quest_limits values ('<user-id>', 20000000) on conflict (user_id) do update set max_bytes = excluded.max_bytes;

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create or replace function private.quest_state_size_check() returns trigger
language plpgsql security definer set search_path = '' as $$
declare lim integer;
begin
  select max_bytes into lim from public.quest_limits where user_id = new.user_id;
  if octet_length(new.state::text) > coalesce(lim, 2000000) then
    raise exception 'Speichergrenze erreicht (% Bytes erlaubt)', coalesce(lim, 2000000) using errcode = 'P0001';
  end if;
  return new;
end $$;
drop trigger if exists quest_state_size on public.quest_state;
create trigger quest_state_size before insert or update on public.quest_state
  for each row execute function private.quest_state_size_check();

-- Höchstens 100 Konten
create or replace function private.limit_user_count() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if (select count(*) from auth.users) >= 100 then
    raise exception 'Maximale Anzahl an Konten erreicht' using errcode = 'P0001';
  end if;
  return new;
end $$;
drop trigger if exists limit_user_count on auth.users;
create trigger limit_user_count before insert on auth.users
  for each row execute function private.limit_user_count();

drop policy if exists "eigene Daten lesen"   on public.quest_state;
drop policy if exists "eigene Daten anlegen" on public.quest_state;
drop policy if exists "eigene Daten ändern"  on public.quest_state;
drop policy if exists "eigene Daten löschen" on public.quest_state;

create policy "eigene Daten lesen"   on public.quest_state for select to authenticated using (auth.uid() = user_id);
create policy "eigene Daten anlegen" on public.quest_state for insert to authenticated with check (auth.uid() = user_id);
create policy "eigene Daten ändern"  on public.quest_state for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "eigene Daten löschen" on public.quest_state for delete to authenticated using (auth.uid() = user_id);

-- Live-Updates: Änderungen auf einem Gerät erscheinen sofort auf den anderen.
do $$ begin
  alter publication supabase_realtime add table public.quest_state;
exception when duplicate_object then null; end $$;
