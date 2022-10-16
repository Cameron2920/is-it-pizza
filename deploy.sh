SSH_URL="root@ramsay.cam"
docker login || { echo "Failed to login to docker"; exit 1; }
docker build -t camcamcam/is-it-pizza -f docker/Dockerfile . || { echo "Failed to build docker image"; exit 1; }
docker push camcamcam/is-it-pizza || { echo "Failed to push docker image"; exit 1; }
rsync -a -e "ssh -i ~/.ssh/server_keys/is-it-pizza" docker $SSH_URL:/var/is-it-pizza/ || { echo "Failed to upload files"; exit 1; }
rsync -a -e "ssh -i ~/.ssh/server_keys/is-it-pizza" start-production-server.sh $SSH_URL:/var/is-it-pizza/ || { echo "Failed to upload files"; exit 1; }
rsync -a -e "ssh -i ~/.ssh/server_keys/is-it-pizza" app.env $SSH_URL:/var/is-it-pizza/ || { echo "Failed to upload files"; exit 1; }
rsync -a -e "ssh -i ~/.ssh/server_keys/is-it-pizza" database.env $SSH_URL:/var/is-it-pizza/ || { echo "Failed to upload files"; exit 1; }
ssh -i ~/.ssh/server_keys/is-it-pizza -t $SSH_URL "cd /var/is-it-pizza/ && ./start-production-server.sh" || { echo "Failed to restart server"; exit 1; }