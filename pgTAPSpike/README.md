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

### pgTAP Spike prototype
This spike prototype was just to use some simple commands from pgTAP on the existing table
covers how to assert that 
- a table exists
- a table has a specified column
- that 2 things are equal

Purpose:

Since we planned to use pgTAP to make unit tests for our database, it was for experimenting with using some basic commands

What was learned:
- how to start a transaction to prevent the tests from affecting the data base
- very basic assertion functions from pgTAP


the code will be in /backend/snippets/pgTAPSpikePrototype.sql


start supabase by following the instructions for "Start backend locally"

Go to the following URL, it is how I was running and editing the code http://localhost:54323/project/default/sql/32cd1247-4bdb-4dca-a318-3b7b4c718dab


