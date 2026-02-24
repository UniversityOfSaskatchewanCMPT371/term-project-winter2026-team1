CREATE TABLE counters
(
    id TEXT PRIMARY KEY,
    count INTEGER NOT NULL DEFAULT 0,
    owner_id TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

INSERT INTO counters(id, owner_id) VALUES ('381bcfe1-b4b4-4ad3-a2cd-8fbfb273bf9c', 1);

CREATE PUBLICATION powersync FOR TABLE counters;