#!/bin/sh
# Build the web server
# Run from root of project
# After completion, launch server with docker-compose up

google-drive-ocamlfuse -label eturkes@bu.edu ~/gdrive \
    && cp -R ~/gdrive/Documents/projects/website-eturkes gdrive \
    && fusermount -u /var/nocow/$HOME/gdrive \
    && docker-compose pull \
    && docker-compose build \
    && docker-compose up -d db \
    && divio project import db gdrive/database.dump \
    && cat gdrive/database.dump | docker exec -i websiteeturkes_db_1 psql -U postgres db \
    && docker-compose run web start migrate \
    && docker-compose run --rm web gulp build \
    && docker-compose run --rm web python manage.py collectstatic \
    && sudo tar -zxf gdrive/media.tar.gz -C data
