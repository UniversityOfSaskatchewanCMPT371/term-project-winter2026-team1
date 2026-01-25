# Flutter + PowerSync + Supabase

A starter project to help you quickly set up and run a local environment with Flutter, PowerSync, and Supabase.

## Prerequisites
You will need the following tools installed on your local machine:
- [Docker](https://docs.docker.com/get-docker/)
- [Supabase CLI](supabase.com/docs/guides/local-development/cli/getting-started)
- [Flutter](https://flutter.dev/docs/get-started/install)

## Configuration

The `./supabase/config.toml` file defines the configuration for your local Supabase instance.

The following settings have already been added and are required for this project:
- `enable_anonymous_sign_ins = true` - Allows clients to generate JWT tokens without signing in using an email/password or OAuth provider. The `./flutter_counter` project is configured to sign users in **anonymously**.
- `signing_keys_path = "./signing_keys.json"` - Enables asymmetric JWTs for your local Supabase instance. 

## Getting Started

Copy the environment template file:
```bash
cp .env.local.template .env.local
```

### 1. Install the Supabase CLI (See [the documentation](https://supabase.com/docs/guides/local-development/cli/getting-started?queryGroups=platform&platform=macos#installing-the-supabase-cli) for more installation options)

### macOS
```bash
brew install supabase/tap/supabase
```

### Windows
```bash
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
```

### 2. Generate Supabase Signing Keys

Run the following command to generate the `./supabase/signing_keys.json` file.
```bash
supabase gen signing-key
```
**WARNING NOTE**:


If you're stuck on that part, ensure supabase is setup, you'll have to do init to do this. make a BACKUP of the **config.toml** inside the /supabase/ file.
If you don't modify the config to allow anonymous clients, it will fail.

Use this once you make backup:
```bash
supabase init
```

Then modify the **config.toml** inside the supabase file
### 3. Start Supabase locally

There is already a migration in `supabase/migrations/20250819090132_counters.sql` that creates the **counters** table, creates the **powersync** publication and seeds one counter record
```bash
supabase start
```

### 4. Start the PowerSync service

The sync rules are already configured in `docker/powersync.yaml` to sync all data from **counters** to all clients.
```bash
docker compose --file ./docker/compose.yaml --env-file .env.local up -d
```

### 5. Run the Flutter Counter Demo

```bash
cd flutter_counter

cp lib/app_config_template.dart lib/app_config.dart

flutter run
```