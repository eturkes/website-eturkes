#!/bin/sh
# Clean up Docker files
# rebuild.sh must be run to use the server again

containers=`docker ps -q`
if [ -n "$containers" ]; then
    docker stop $(docker ps -q)
fi

docker system prune -f
