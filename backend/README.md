# Backend - Supabase Setup

We will need to install the supabase cli to run supabase locally.
Please refer to the [supabase cli docs](https://supabase.com/docs/guides/local-development/cli/getting-started) for more information.

## Requirements
- [Docker](https://docs.docker.com/get-docker/)
- [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started)
- [Scoop for windows](https://scoop.sh/)

### MacOS
``` bash
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


## Generating migrations
```bash
$ supabase migration new <migration name>
```