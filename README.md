# Frontend (Flutter) + Backend (PowerSync + Supabase)

## Prerequisites

You will need the following tools installed on your local machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Flutter](https://flutter.dev/docs/get-started/install)

### 1. Start backend locally

This will start pur backend service (supabase) locally assuming setup was
already completed

```bash
$ cd backend
$ supabase start
$ docker compose up --build
```

### 2. Run the search_cms app

```bash
$ cd frontend/search_cms
$ flutter run
```
