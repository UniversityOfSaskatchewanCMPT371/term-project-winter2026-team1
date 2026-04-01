-- An Assemblage in a Level. In arch, an assemblage is a group of different artifacts 
-- found together within the same the same context (e.g., level, site, etc.)
CREATE TABLE assemblage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    level_id UUID NOT NULL,
    name TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(), -- For admin editing purposes
    FOREIGN KEY (level_id) REFERENCES level(id) ON DELETE CASCADE
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE assemblage ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on assemblage"
ON assemblage
FOR SELECT
TO authenticated
USING (true);

-- Enable authenticated insert of new data
CREATE POLICY "Allow authenticated insert on assemblage"
ON assemblage
FOR INSERT
TO authenticated
WITH CHECK (true);

-- An Artifact in an Assemblage
CREATE TABLE artifact_faunal (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assemblage_id UUID NOT NULL,
    porosity INTEGER,
    size_upper REAL,
    size_lower REAL,
    comment TEXT,
    pre_excav_frags INTEGER NOT NULL DEFAULT 1,
    post_excav_frags INTEGER NOT NULL DEFAULT 1,
    elements INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(), -- For admin editing purposes 
    FOREIGN KEY (assemblage_id) REFERENCES assemblage(id) ON DELETE CASCADE,

    CONSTRAINT artifact_faunal_size_check 
        CHECK (
            size_upper IS NULL 
            OR size_lower IS NULL 
            OR size_upper >= size_lower
        ),

    CONSTRAINT artifact_faunal_porosity_check 
        CHECK (
            porosity IS NULL
            OR (porosity > 0) AND (porosity <= 5)
        )
);

-- Enable RLS policy. For now, allow all authenticated users to read data
ALTER TABLE artifact_faunal ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated read on artifact_faunal"
ON artifact_faunal
FOR SELECT
TO authenticated
USING (true);

-- Enable authenticated insert of new data
CREATE POLICY "Allow authenticated insert on artifact_faunal"
ON artifact_faunal
FOR INSERT
TO authenticated
WITH CHECK (true);
