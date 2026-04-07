CREATE PUBLICATION powersync FOR ALL TABLES;

-- roles for user login
create table public.role (
  id uuid not null,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  role text not null,
  constraint role_pkey primary key (id),
  constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;

-- Enable RLS policy. Prevent users from reading other users roles
alter table public.role enable row level security;

create policy "User can only read their own role"
on role
for select
to authenticated
using (auth.uid() = id);

-- A Site represents the top-level in the system
CREATE TABLE site (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT DEFAULT '', -- Can be empty
    borden VARCHAR(8) NOT NULL UNIQUE, -- Limit 8 from the provided dump file
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now() -- For admin editing purposes
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE site ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on site"
ON site
FOR SELECT
TO authenticated
USING (true);

-- Enable authenticated insert of new data
CREATE POLICY "Allow authenticated insert on site"
ON site
FOR INSERT
TO authenticated
WITH CHECK (true);
