# sEARCH CMS Frontend

Authentication feature

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- Dart dependencies installed (run `flutter pub get`)

## Running the App

1. Install dependencies:

```bash
flutter pub get
```

## 2. Run the app

Start the backend
Supabase dashboard URL: http://localhost:54323/

Create the user from the Supabase authentication dashboard

Create the role table with the following command

```
create table public.role (
  id uuid not null,
  created_at timestamp with time zone not null default (now() AT TIME ZONE 'utc'::text),
  role text not null,
  constraint role_pkey primary key (id),
  constraint role_id_fkey foreign KEY (id) references auth.users (id) on update CASCADE on delete CASCADE
) TABLESPACE pg_default;
```

Create the role for the user

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