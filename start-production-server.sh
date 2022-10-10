if [ "$REBUILD" = "true" ]; then
  docker compose -f ./docker/docker-compose.yml \
    -f ./docker/docker-compose-production.yml build
  docker compose -f ./docker/docker-compose.yml \
    -f ./docker/docker-compose-production.yml down
fi

docker compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-production.yml up