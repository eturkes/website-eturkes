#!/bin/sh
# Clean up Docker files

containers=`docker ps -q`
if [ -n "$containers" ]; then
    docker stop $(docker ps -q)
fi

docker system prune -f
