-- An Area in a Site. A Site can have multiple areas
CREATE TABLE area (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now() -- For admin editing purposes
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE area ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on area"
ON area
FOR SELECT
TO authenticated
USING (true);

-- An intermediate table for Site and Area as per the ER diagram 
CREATE TABLE site_area (
    site_id UUID NOT NULL,
    area_id UUID NOT NULL, -- Using area_id instead of location_id for consistent naming
    PRIMARY KEY (site_id, area_id),
    FOREIGN KEY (site_id) REFERENCES site(id) ON DELETE CASCADE,
    FOREIGN KEY (area_id) REFERENCES area(id) ON DELETE CASCADE
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE site_area ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on site_area"
ON site_area
FOR SELECT
TO authenticated
USING (true);

-- A Unit in a Site. Defined as the measured area where excavation takes place. A Site can have multiple units
CREATE TABLE unit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Using site_id for now for ID3 while further study about Excavation is being done by the stakeholder
    -- excavation_id UUID NOT NULL,
    site_id UUID NOT NULL,

    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(), -- For admin editing purposes

    FOREIGN KEY (site_id) REFERENCES site(id) ON DELETE CASCADE
    -- FOREIGN KEY (excavation_id) REFERENCES excavation(id) ON DELETE CASCADE
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE unit ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on unit"
ON unit
FOR SELECT
TO authenticated
USING (true);

-- A Level in a Unit. Defined as the vertical unit of control, typically 10 cm thick. A Unit can have multiple levels
CREATE TABLE level (
    id UUID DEFAULT gen_random_uuid(),
    unit_id UUID NOT NULL,
    parent_id UUID, -- Top-most level in a unit should not have a parent
    name TEXT NOT NULL,
    up_limit SMALLINT DEFAULT 0,
    low_limit SMALLINT DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(), -- For admin editing purposes

    -- Composite primary key as per the ER diagram. If no crossing allowed (a parent level must belong to the same unit), then
    PRIMARY KEY (id, unit_id),
    UNIQUE(id), -- Since ID is not the only PK, make it unique for Assemblage to refer

    FOREIGN KEY (unit_id) REFERENCES unit(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id, unit_id) REFERENCES level(id, unit_id) ON DELETE CASCADE,

    -- Below are from the provided dump file. Can be used if needed
    level_char VARCHAR(1),
    level_int SMALLINT,
    CONSTRAINT level_check CHECK (up_limit <= low_limit)
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE level ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on level"
ON level
FOR SELECT
TO authenticated
USING (true);

