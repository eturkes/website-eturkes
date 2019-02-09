#!/bin/sh

# Clean up Docker files
# rebuild.sh must be run to use the server again

CONTAINERS=`docker ps -q`
if [ -n "$CONTAINERS" ]; then
    docker stop $(docker ps -q)
fi

docker system prune -f
