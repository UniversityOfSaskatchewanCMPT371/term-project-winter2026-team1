# Backend - Supabase Setup

This directory contains the configuration to run Supabase locally using Docker.

## Running Supabase

1.  **Start the container**:
    ```bash
    docker compose up -d
    ```

2.  **Start Supabase services**:
    ```bash
    docker compose exec ubuntu_container supabase start
    ```

    To stop services:
    ```bash
    docker compose exec ubuntu_container supabase stop
    ```

## Port Mappings

When Supabase is running, the following services are available on your host machine (`localhost`):

| Service | Port | Description |
| :--- | :--- | :--- |
| **Studio** | `54323` | [Supabase Studio](http://localhost:54323) - Visual interface for managing your project (Tables, SQL, Auth, etc.) |
| **API** | `54321` | [Rest API](http://localhost:54321) - Use this URL to connect your frontend apps. |
| **Database** | `54322` | Direct PostgreSQL connection. Connection string: `postgresql://postgres:postgres@localhost:54322/postgres` |
| **Inbucket** | `54324` | [Email Testing](http://localhost:54324) - View emails sent by Supabase Auth (e.g. magic links). |
| **Analytics** | `54327` | Analytics server (Postgres backend). |
| **DB Shadow** | `54320` | Internal shadow database for diffing. |

### Why are these ports available on localhost?
The Supabase CLI inside the `ubuntu_container` uses the host's Docker daemon (via `/var/run/docker.sock`). When it spawns the Supabase service containers, it publishes their ports directly to your host's network interface. This means you can access them as if you ran `supabase start` directly on your Mac.
