-- BALAJI AUTOMOBILES CRM V2 - SUPABASE SETUP
-- Run this whole script in Supabase SQL Editor.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'staff' check (role in ('admin','staff')),
  created_at timestamptz not null default now()
);

create table if not exists public.enquiries (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  mobile text not null,
  village text,
  model text,
  payment text not null default 'Cash' check (payment in ('Cash','Finance')),
  exchange text not null default 'No' check (exchange in ('Yes','No')),
  enquiry_date date not null default current_date,
  followup_date date,
  delivery_date date,
  status text not null default 'New' check (status in ('New','Follow-up','Interested','Converted','Lost')),
  notes text,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.enquiries enable row level security;

drop policy if exists "profiles read own" on public.profiles;
create policy "profiles read own" on public.profiles
for select to authenticated using (id = auth.uid());

drop policy if exists "enquiries authenticated read" on public.enquiries;
create policy "enquiries authenticated read" on public.enquiries
for select to authenticated using (true);

drop policy if exists "enquiries authenticated insert" on public.enquiries;
create policy "enquiries authenticated insert" on public.enquiries
for insert to authenticated with check (created_by = auth.uid());

drop policy if exists "enquiries authenticated update" on public.enquiries;
create policy "enquiries authenticated update" on public.enquiries
for update to authenticated using (true) with check (true);

drop policy if exists "enquiries authenticated delete" on public.enquiries;
create policy "enquiries authenticated delete" on public.enquiries
for delete to authenticated using (true);

-- Automatically create a staff profile whenever a new Auth user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, role)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name',''), 'staff')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- After creating your first account in the app, make it admin:
-- UPDATE public.profiles SET role='admin' WHERE id='YOUR_USER_UUID';
