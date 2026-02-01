# Backend - Supabase Setup

We will need to install the supabase cli to run supabase locally. Please refer
to the
[supabase cli docs](https://supabase.com/docs/guides/local-development/cli/getting-started)
for more information.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started)
- [Scoop for windows](https://scoop.sh/)

### MacOS

```bash
$ brew install supabase/tap/supabase
```

### Windows

You need to install scoop first via powershell

```powershell
$ Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

Then you can install supabase

```powershell
$ scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
$ scoop install supabase
```

Run supabase locally On windows, you need to expose Docker daemon on
tcp://localhost:2375. Go to Settings -> General -> Expose daemon on
tcp://localhost:2375 without TLS. Refer to
[supabase on windows docs](https://supabase.com/docs/guides/local-development/cli/getting-started?queryGroups=platform&platform=windows#running-supabase-locally)
for more information.

## Running supabase

```bash
$ cd backend/
$ supabase start
```

## Generating migrations

```bash
$ supabase migration new <migration name>
```
