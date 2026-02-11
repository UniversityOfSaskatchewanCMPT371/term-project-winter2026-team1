# Frontend (Flutter) + Backend (PowerSync + Supabase)

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

### 2. Run the Flutter Counter Demo

```bash
cd frontend/flutter_counter

cp lib/app_config_template.dart lib/app_config.dart

flutter run
```
