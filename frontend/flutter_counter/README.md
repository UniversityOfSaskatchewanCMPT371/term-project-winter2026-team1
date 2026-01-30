# Getting Started

A demo Flutter app that demonstrates real-time counter functionality powered by a locally hosted Supabase backend and PowerSync for data synchronization.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A PowerSync hosted backend set up (refer to [PowerSync documentation](https://docs.powersync.com/) for setup instructions)
- Dart dependencies installed (run `flutter pub get`)

## Running the App

1. Install dependencies:

```bash
flutter pub get
```

## 2. Configure PowerSync

- Copy the template config file and rename it:

```bash
  cp lib/app_config_template.dart lib/app_config.dart
```

- Open `lib/app_config.dart` and insert your `powerSyncUrl` and `backendUrl`.

## 3. Run the app

To run the `web` build, ensure you have a `/web/sqlite3.wasm` file present. This WebAssembly file is required for SQLite functionality on the web.

To download the required WASM file, run:
```bash
 dart run powersync:setup_web --no-worker
```

```bash
flutter run
```
