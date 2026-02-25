# Team 1 - sEARCH CMS/API

## Team Members & Stakeholders

### Team Members
- Martin Thingvold (Project Manager)
- Theo Buckley (Build Master)
- Talha Hassan (Risk Manager)
- Huayi Huang (Development Lead)
- Matt Berry (Test Lead)
- Sayem Khondaker (Developer/Tester)
- Yousif Warda (Developer/Tester)
- Jonathan Mutakura (Developer/Tester)
- Mandeep Bawa (Developer/Tester)
- Himanshu Goyal (Developer/Tester)
- Jacob Evertman (Developer/Tester)
- Tyler Chow (Developer/Tester)

### Stakeholders
- Bennett Lewis, MSc., Department of Computer Science, USask
- Dr. Glenn Stuart, Associate Professor, Department of Anthropology, USask
- Dr. Terrence Clark, Associate Professor Department of Anthropology, USask; Director of sARP (shíshálh Archaeological Research Project)
- Dr. Tina Greenfield, Research Associate, McDonald Institute for Archaeological Research, and Assistant Professor, Mesopotamian Archaeology, University of Cambridge
- shíshálh Nation of British Columbia

---

## About The Project: sARP/sEARCH
sEARCH is part of a larger project known as sARP, a community-based collaboration of the University of Saskatchewan Department of Anthropology and the shìshàlh Nation of British Columbia. sARP has been investigating long-term resource use, status inequality, mortuary practices, settlement patterns, territoriality, and ritual within shíshálh lands. sEARCH aims to increase our knowledge of sustainability strategies in the shíshálh Nation lands by examining relationships between human food economy, diet, mobility, and environmental (plant/animal) management strategies from time immemorial through to the present.

(*Description provided by the stakeholders*).

---

## Project Development
Team progress through each incremental deliverable can be found in the [wiki](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-winter2026-team1/wiki). The wiki also contains more important documentations of the project.

---

## Tech Stack 
- Frontend: Flutter
- Backend: PowerSync + Supabase
- DevOps: Docker

---

## Installation

### Prerequisites
You will need the following tools installed on your local machine:
- [Docker](https://docs.docker.com/get-docker/)
- [Flutter](https://flutter.dev/docs/get-started/install)

### Backend - Supabase & PowerSync Setup
This will start pur backend service (Supabase + PowerSync) locally

```bash
cd backend
```

This directory contains the configuration to run Supabase & PowerSync locally using Docker.

### Windows Setup (WSL 2)

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

### Run the Flutter App

1. **Navigate to the frontend**:
```bash
cd frontend/search_cms
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Setup User and Role**:

    3.1. Once the app is running, head to the backend Supabase dashboard at: http://localhost:54323/
   
    3.2. From the left sidebar, go to Authentication &rarr; Add user.
   
    3.3. Create a new user with random email and password. Once done, you will be given an UID. Please copy this for step 3.6.
   
    3.4. From the left sidebar, go to SQL Editor and then run this query to create the `role` table:
    ```
    create table public.role (
      id uuid not null,
      created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
      role text not null,
      constraint role_pkey primary key (id),
      constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
    ) TABLESPACE pg_default;
    ```
    3.5. From the left sidebar, go to Table Editor &rarr; role &rarr; Insert &rarr; Insert row.
   
    3.6. Add a new role by using the same ID from step 3.3 and input "viewer" in the role text box. Click Save to add it.
   
4. **Run the app**:
```bash
flutter run
```

5. **You can now use the app using the email and password you created in step 3.3.**

### Run Unit Tests

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

config folder holds the database keys and initialization routines.
utils folder holds the constants file, the main injection files and the result class template.

For full info on the architecture, please see: [Architecture Guide Wiki](https://github.com/UniversityOfSaskatchewanCMPT371/term-project-winter2026-team1/wiki/Architecture-Guide)
