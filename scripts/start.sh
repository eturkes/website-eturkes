#!/bin/sh
# Start the web server after building

~./scripts/nginx-proxy.sh \
    && ./scripts/letsencrypt-nginx-proxy-companion.sh \
    && docker-compose up
