#!/bin/sh

# Step 1 in running an SSL reverse proxy

docker run -d -p 80:80 -p 443:443 \
    --name nginx-proxy \
    -v /etc/letsencrypt-nginx-proxy-companion:/etc/nginx/certs:ro \
    -v /etc/nginx/vhost.d \
    -v /usr/share/nginx/html \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
    jwilder/nginx-proxy
