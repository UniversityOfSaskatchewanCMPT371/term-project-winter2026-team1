#!/bin/bash

# Function to handle shutdown
cleanup() {
    echo "Shutting down Supabase..."
    supabase stop
    exit 0
}

# Trap SIGTERM and SIGINT
trap cleanup SIGTERM SIGINT

SIGNING_KEY_FILE="./supabase/signing_keys.json"

if [ -f "$SIGNING_KEY_FILE" ] && [ -s "$SIGNING_KEY_FILE" ]; then
    echo "$SIGNING_KEY_FILE already exists and is not empty, ignoring..."
else
    echo "Generating signing keys..."
    if echo "[$(supabase gen signing-key)]" > ./supabase/signing_keys.tmp; then
        mv ./supabase/signing_keys.tmp "$SIGNING_KEY_FILE"
        echo "Successfully generated $SIGNING_KEY_FILE"
    else
        echo "ERROR: supabase gen signing-key failed!"
        exit 1
    fi
fi

cp ./supabase/backup-config.toml ./supabase/config.toml
echo "Starting Supabase..."
supabase start --debug

# we use a loop with 'sleep' so signals can be trapped effectively
while true; do
    sleep 1 & wait $!
done
