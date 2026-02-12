# Backend - Supabase & Powersync Setup

This directory contains the configuration to run Supabase & Powersync locally using Docker.

## Windows Setup (WSL 2)

If you are on Windows, you likely need to use WSL 2 to avoid the path formatting issue (i.e. "too many colons").

1.  **Ensure WSL is Installed**:
    Open PowerShell as Administrator and run:
    ```powershell
    wsl --install
    ```
2.  **Configure Docker Desktop**:
    - **Settings -> General**: Ensure "Use the WSL 2 based engine" is CHECKED.
    - **Resources -> WSL Integration**: Ensure your directory (e.g. Ubuntu) is toggled ON.
3.  **Open Project in WSL**:
    - Open the "Ubuntu" app or type `wsl` in your terminal.
    - Navigate to the project (i.e `/mnt/c/Users/your-user/Desktop/cmpt/term-project-winter2026-team1/`)

## Running Supabase

1.  **Start the container**:
    ```bash
    docker compose up --build -d
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