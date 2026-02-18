#!/usr/bin/env bash

set -euo pipefail


#Adding basic variables that follows the current files & names


file="backend/docker-compose.yml"
svc="ubuntu_vm"

#Estimation between the amount of times thats it tries to reach the backend and the amount of time that the script will have to wait
tries=25
sleep_s=5



