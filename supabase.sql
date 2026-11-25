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

-- Größenbremse: ein Konto kann den Speicher nicht volllaufen lassen (normal sind wenige KB).
alter table public.quest_state drop constraint if exists quest_state_size;
alter table public.quest_state add constraint quest_state_size check (octet_length(state::text) <= 2000000);

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
