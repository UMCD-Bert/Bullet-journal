-- Bullet Journal: tabel + beveiliging. Uitgevoerd op project "Huishouden" (vlhjikyslkkekxtapzqj)
-- als migratie `bujo_entries` op 2026-10-31.

create table public.bujo_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  log text not null check (log in ('daily','monthly','future')),
  log_date date not null,
  kind text not null default 'task' check (kind in ('task','event','note')),
  status text not null default 'open' check (status in ('open','done','migrated','scheduled','cancelled')),
  priority boolean not null default false,
  content text not null,
  sort_order integer not null default 0,
  migrated_from uuid references public.bujo_entries(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index bujo_entries_user_log_idx on public.bujo_entries (user_id, log, log_date);

alter table public.bujo_entries enable row level security;

-- Alleen ingelogde gebruikers, alleen eigen rijen (anders dan de open Huishouden-tabellen).
create policy "bujo eigen entries" on public.bujo_entries
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create or replace function public.bujo_set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger bujo_entries_updated_at before update on public.bujo_entries
  for each row execute function public.bujo_set_updated_at();
