CREATE PUBLICATION powersync FOR ALL TABLES;

-- roles for user login
create table public.role (
  id uuid not null,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  role text not null,
  constraint role_pkey primary key (id),
  constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;

-- site entity table
-- each site is uniquely identified by a 8 character borden
CREATE TABLE site (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT DEFAULT '', -- Can be empty
    borden VARCHAR(8) NOT NULL UNIQUE, -- Limit 8 from the provided dump file
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now() -- For admin editing purposes
);


