if [ "$1" = "production" ]; then
    ENV_FILE="app.env"
    SSH_URL="root@178.128.135.203"
    echo "Loading Production Environment."
else
    echo "Unknown Environment."
    exit 1
fi

if test -z "$2"; then
    RAILS_COMMAND="rails c"
else
    RAILS_COMMAND="$2"
fi
set -o allexport; source $ENV_FILE; set +o allexport
export REMOTE_DATABASE_HOST=localhost
export REMOTE_DATABASE_PORT=5099
export DATABASE_HOST=localhost
export DATABASE_PORT=$((((RANDOM<<15)|RANDOM) % 63001 + 2000))
ssh -i ~/.ssh/server_keys/is-it-pizza -M -S ssh-socket -fnNT -L $DATABASE_PORT:$REMOTE_DATABASE_HOST:$REMOTE_DATABASE_PORT $SSH_URL
spring stop
eval $RAILS_COMMAND
ssh -S ssh-socket -O exit $SSH_URL