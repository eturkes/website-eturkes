#!/bin/sh
# Backup the web server
# Run from root of project

google-drive-ocamlfuse -label eturkes@bu.edu ~/gdrive \
    && mv binary/database.dump binary/media.tar.gz binary/old \
    && docker exec websiteeturkes_db_1 pg_dump -U postgres db > binary/database.dump \
    && cd data \
    && sudo tar -zcf ../binary/media.tar.gz ./ \
    && cd .. \
    && sudo chown suse1:users binary/media.tar.gz \
    && cp -R binary/* binary/.[!.]* ~/gdrive/Documents/projects/website-eturkes \
    && fusermount -u /var/nocow/$HOME/gdrive
