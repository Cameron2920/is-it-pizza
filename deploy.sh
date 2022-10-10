docker build -t camcamcam/is-it-pizza -f docker/Dockerfile . || { echo "Failed to build docker image"; exit 1; }
docker push camcamcam/is-it-pizza || { echo "Failed to push docker image"; exit 1; }
# upload docker directory and start-production-server command to remote host
# run start-production-server on remote