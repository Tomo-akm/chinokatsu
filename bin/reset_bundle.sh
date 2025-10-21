#!/usr/bin/env bash

set -e

TARGET_VOLUME='chinokatsu_bundle'

echo "Stopping containers..."
docker compose down

echo "Removing exited containers using volume: $TARGET_VOLUME..."
docker ps -a --quiet --filter "status=exited" --filter "volume=$TARGET_VOLUME" | while read LINE
do
  if [ -n "$LINE" ]; then
    echo "Removing container: $LINE"
    docker container rm $LINE
  fi
done

echo "Removing volume: $TARGET_VOLUME..."
docker volume rm $TARGET_VOLUME || echo "Volume $TARGET_VOLUME does not exist or already removed"

echo "Done! Run 'docker compose up' to rebuild."
