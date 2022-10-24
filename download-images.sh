if [ "$1" = "production" ]; then
    ENV_FILE="app.env"
    SSH_URL="root@178.128.135.203"
    echo "Loading Production Environment."
else
    echo "Unknown Environment."
    exit 1
fi
ssh -i ~/.ssh/server_keys/is-it-pizza $SSH_URL 'tar -zcvf pizza_images.tar.gz /var/is-it-pizza/public/system/questionable_pizzas/pizza_images/'
scp -i ~/.ssh/server_keys/is-it-pizza $SSH_URL:/root/pizza_images.tar.gz .
mkdir image_export
tar -xvf pizza_images.tar.gz -C image_export