#!/bin/sh
# Start the web server after building

./helper-scripts/nginx-proxy.sh \
    && ./helper-scripts/letsencrypt-nginx-proxy-companion.sh \
    && docker-compose up
