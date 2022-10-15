docker-compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-production.yml stop app
docker-compose -f ./docker/docker-compose.yml \
  -f ./docker/docker-compose-production.yml up -d