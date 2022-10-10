docker-compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-production.yml down
docker-compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-production.yml up -d