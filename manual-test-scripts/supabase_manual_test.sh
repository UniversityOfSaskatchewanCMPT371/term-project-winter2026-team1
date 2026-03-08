#!/usr/bin/env bash

set -euo pipefail


#Adding basic variables that follows the current files & names
file="backend/docker-compose.yml"
svc="ubuntu_vm"

#Estimation between the amount of times thats it tries to reach the backend and the amount of time that the script will have to wait
tries=25
sleep_s=5


#docker compose command throgh the script
#
compose() {
  docker compose -f "$file" "$@"
}

# waits until curl can connect to the URL (curl exit code 0 = success)
wait_up() {
  url="$1"
  i=1
  while [ $i -le $tries ]; do
    if curl -s "$url" >/dev/null; then
      return 0
    fi
    sleep "$sleep_s"
    i=$((i+1))
  done
  return 1
}

#if its fails therefore will echo Fail
fail() {
  echo "FAIL: $1"
  exit 1
}


#cleanups and starts the current script

cleanup() {

 # stops the supabase with the compose stack included
  compose exec -T "$svc" supabase stop || true
  compose down -v || true

  # deletes the supabase containers from the supabase start included 
  # dockers names based on the supoabase and backend included
	
  name_field='{{.Names}}'
  docker ps -a --format "$name_field" \
    | grep supabase_ \
    | grep _backend \
    | xargs -r docker rm -f || true
}
trap cleanup EXIT

# shuts down anything already running (so we start clean AND fresh)
compose down -v || true
name_field='{{.Names}}'
docker ps -a --format "$name_field" \
  | grep supabase_ \
  | grep _backend \
  | xargs -r docker rm -f || true ##reads the stanard input and executes the command

#starts the backend containers using the following command using the ubuntu_wm and powersync together   
compose up -d --build

#Makes sure that supabase gets restarted at some point
compose exec -T "$svc" supabase stop || true
compose exec -T "$svc" supabase start

#waits and checks that all backedn services are in a connectable state

#services that are listed for the backend (github README.md)
wait_up "http://127.0.0.1:54321" || fail "Supabase API not reachable"          # supabase gateway / API
wait_up "http://127.0.0.1:54323" || fail "Supabase Studio not reachable"         # supabase studio
wait_up "http://127.0.0.1:8080"  || fail "PowerSync not reachable"         # powersync
wait_up "http://127.0.0.1:54321/rest/v1"  || fail "Supabase REST not reachable"  # supabase REST

echo "Everything was Successfull... Results: PASS"
