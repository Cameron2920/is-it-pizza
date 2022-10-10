#!/bin/bash

# Script for running commands within the local docker container.
# Usage: ./dev-console.sh [command]
# Will start a bash session if no [command] is specified
#
# Example running rake task: ./dev-console.sh 'rake db:migrate'

if [ "$REBUILD" = "true" ]; then
  docker compose -f ./docker/docker-compose.yml \
    -f ./docker/docker-compose-development.yml build
fi

if [ "$STOP" = "true" ]; then
  docker compose -f ./docker/docker-compose.yml \
    -f ./docker/docker-compose-development.yml down
  exit 0
fi
docker compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-development.yml up -d

if test -z "$1"; then
  COMMAND="bash"
else
  COMMAND="$1"
fi

docker compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-development.yml \
  exec -u app-user app $COMMAND
