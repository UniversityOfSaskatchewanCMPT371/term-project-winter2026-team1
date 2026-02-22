
CREATE TABLE site (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    borden VARCHAR(8) NOT NULL UNIQUE, -- Limit 8 from the provided dump file
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now() -- For admin editing purposes
);

CREATE TABLE area (
    area_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now() -- For admin editing purposes
);

CREATE TABLE site_area (
    site_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL, -- Using area_id instead of location_id for consistent naming
    PRIMARY KEY (site_id, area_id),
    FOREIGN KEY (site_id) REFERENCES site(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES area(area_id) ON DELETE CASCADE
);

CREATE TABLE unit (
    unit_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    site_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(), -- For admin editing purposes
    FOREIGN KEY (site_id) REFERENCES site(id) ON DELETE CASCADE

    -- For later
    -- FOREIGN KEY (excav_id) REFERENCES excavation(id) ON DELETE CASCADE, -- For later
);

CREATE TABLE level (
    level_id INTEGER GENERATED ALWAYS AS IDENTITY,
    unit_id INTEGER NOT NULL,
    parent_id INTEGER, -- Top-most level in a unit should not have a parent
    name TEXT NOT NULL,
    up_limit SMALLINT DEFAULT 0,
    low_limit SMALLINT DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(), -- For admin editing purposes

    -- Composite primary key as per the ER diagram
    PRIMARY KEY (level_id, unit_id),
    FOREIGN KEY (unit_id) REFERENCES unit(unit_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id, unit_id) REFERENCES level(level_id, unit_id) ON DELETE CASCADE,

    -- Below are from the provided dump file. Can be used if needed
    level_char VARCHAR(1),
    level_int SMALLINT,
    CONSTRAINT level_check CHECK (up_limit <= low_limit)
);

create table public.role (
  id uuid not null,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  role text not null,
  constraint role_pkey primary key (id),
  constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;

