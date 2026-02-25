# Team 1: sEARCH CMS/API

## Frontend (Flutter) + Backend (PowerSync + Supabase)

---

## Prerequisites
You will need the following tools installed on your local machine:
- [Docker](https://docs.docker.com/get-docker/)
- [Flutter](https://flutter.dev/docs/get-started/install)

---

## Backend - Supabase & PowerSync Setup
This will start pur backend service (Supabase + PowerSync) locally

```bash
cd backend
```

This directory contains the configuration to run Supabase & PowerSync locally using Docker.

---

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

### Running Supabase

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

### Port Mappings

When Supabase is running, the following services are available on your host machine (`localhost`):

| Service | Port | Description |
| :--- | :--- | :--- |
| **Studio** | `54323` | [Supabase Studio](http://localhost:54323) - Visual interface for managing your project (Tables, SQL, Auth, etc.) |
| **API** | `54321` | [Rest API](http://localhost:54321) - Use this URL to connect your frontend apps. |
| **Database** | `54322` | Direct PostgreSQL connection. Connection string: `postgresql://postgres:postgres@localhost:54322/postgres` |
| **Inbucket** | `54324` | [Email Testing](http://localhost:54324) - View emails sent by Supabase Auth (e.g. magic links). |
| **Analytics** | `54327` | Analytics server (Postgres backend). |
| **DB Shadow** | `54320` | Internal shadow database for diffing. |

---

## Run the Flutter App

1. **Navigate to the frontend**:
```bash
cd frontend/search_cms
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Run the app**:
```bash
flutter run
```

### Setup User and Role

1. Once the app is running, head to the backend Supabase dashboard at: http://localhost:54323/
2. From the left sidebar, go to Authentication &rarr; Add user.
3. Create a new user with random email and password. Once done, you will be given an UID. Please copy this for step 6.
4. From the left sidebar, go to SQL Editor and then run this query to create the `role` table:
```
create table public.role (
  id uuid not null,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  role text not null,
  constraint role_pkey primary key (id),
  constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
```
5. From the left sidebar, go to Table Editor &rarr; role &rarr; Insert &rarr; Insert row.
6. Add a new role by using the same ID from step 3 and input "viewer" in the role text box. Click Save to add it.
7. Finally, you can now use the app with the same email and password created in step 3.

---

## Run Unit Tests

1. **Generate mocks**:
```bash
 flutter pub run build_runner build
```

2. **Run the tests**:
```bash
flutter test
```

---

## System Architecture

Clean architecture breaks the application into different features, with
a presentation layer, a domain layer and a data layer for each individual feature.

The flutter source files are in the lib folder.

main.dart is the entry point for the app.

config folder holds the database keys and inialization routines.
utils folder holds the constants file, the main injection files and the result class template.

In the counters feature folder, the important components are Bloc, usecases, repositories and APIs.

It follows the sequence:  
Bloc -> Usecases -> Repositories -> APIs

Each component is cleanly separated, and can be swapped easily.
