# sEARCH CMS Frontend

A clean architecture Flutter app with a locally hosted powersync and Supabase backend.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- Dart dependencies installed (run `flutter pub get`)

## Running the App

1. Install dependencies:

```bash
flutter pub get
```

## 2. Run the app

```bash
flutter run
```


# Explanation of Organization

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