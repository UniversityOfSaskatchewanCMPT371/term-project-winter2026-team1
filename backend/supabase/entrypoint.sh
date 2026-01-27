#!/bin/bash

# Function to handle shutdown
cleanup() {
    echo "Shutting down Supabase..."
    supabase stop
    exit 0
}

# Trap SIGTERM and SIGINT
trap cleanup SIGTERM SIGINT

echo "Starting Supabase..."
supabase start

# wait indefinitely while keeping the script alive to receive signals
# we use a loop with 'sleep' so signals can be trapped effectively
while true; do
    sleep 1 & wait $!
done
