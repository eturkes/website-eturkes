#!/bin/sh
# Step 2 in running an SSL reverse proxy

docker run -d \
    -v /etc/letsencrypt-nginx-proxy-companion:/etc/nginx/certs:rw \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    --volumes-from nginx-proxy \
    jrcs/letsencrypt-nginx-proxy-companion
