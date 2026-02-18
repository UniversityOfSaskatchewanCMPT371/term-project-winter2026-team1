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
