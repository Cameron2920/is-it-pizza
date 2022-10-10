#!/bin/bash

# Script for running commands within the local docker container.
# Usage: ./dev-console.sh [command]
# Will start a bash session if no [command] is specified
#
# Example running rake task: ./dev-console.sh 'rake db:migrate'
VOLUME_MOUNT_FILE_NAME="docker-compose-development-volume-mount"
DOCKER_COMPOSE_COMMAND="exec"

if [ "$TESTING" = "true" ]; then
  VOLUME_MOUNT_FILE_NAME="docker-compose-test-volume-mount"
  DOCKER_COMPOSE_COMMAND="run"
fi

if [ "$REBUILD" = "true" ]; then
  docker compose -f ./docker/docker-compose-development.yml \
    -f ./docker/$VOLUME_MOUNT_FILE_NAME.yml build
fi

if [ "$STOP" = "true" ]; then
  docker compose -f ./docker/docker-compose-development.yml \
    -f ./docker/$VOLUME_MOUNT_FILE_NAME.yml down
  exit 0
fi
docker compose -f ./docker/docker-compose-development.yml \
  -f ./docker/$VOLUME_MOUNT_FILE_NAME.yml up -d

if test -z "$1"; then
  COMMAND="bash"
else
  COMMAND="$1"
fi

docker compose -f ./docker/docker-compose-development.yml \
  -f ./docker/$VOLUME_MOUNT_FILE_NAME.yml \
  $DOCKER_COMPOSE_COMMAND -u Pharmacy pharmacy $COMMAND
