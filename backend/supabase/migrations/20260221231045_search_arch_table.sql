create table public.role (
  id uuid not null,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  role text not null,
  constraint role_pkey primary key (id),
  constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;

