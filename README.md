# Frontend (Flutter) + Backend (PowerSync + Supabase) + Nightly Desktop Builds

## Prerequisites
You will need the following tools installed on your local machine:
- [Docker](https://docs.docker.com/get-docker/)
- [Flutter](https://flutter.dev/docs/get-started/install)


### 1. Start backend locally
This will start pur backend service (supabase + powersync) locally

```bash
cd backend
docker compose up -d --build
```

Go to http://localhost:54323/ and check if there is counters table set up in the table editor.

If there is no such table, please run the following SQL commands to set up the table.

```
CREATE TABLE counters (
    id TEXT,
    count INTEGER,
    owner_id INTEGER,
    created_at TIMESTAMPTZ,
    modified_at TIMESTAMPTZ
);
```

```
INSERT INTO counters (id, count, owner_id, created_at, modified_at)
VALUES ('123', 0, 1, '2026-02-01 0:00:00-00:00', '2026-02-01 0:00:00-00:00');
```

### 2. Run the Flutter Counter Demo

```bash
cd frontend/flutter_counter

flutter run
```

---

## Nightly Desktop Builds
The project automatically builds desktop binaries (Windows, macOS, Linux) every night using GitHub Actions.

The workflow:
- Builds from `main` branch
-  Runs daily at 12 am SK time (06:00 UTC); can be adjusted as needed
- Creates or updates a prerelease tagged `nightly`
- Replace artifacts each run

You can download latest binaries from:

GitHub &rarr; Releases &rarr; Nightly

To trigger manually:

GitHub &rarr; Actions &rarr; Flutter Desktop Nightly &rarr; Run workflow
