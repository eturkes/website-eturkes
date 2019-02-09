#!/bin/sh
# Backup the web server
# Run from root of project
# Use while server is running

google-drive-ocamlfuse -label eturkes@bu.edu ~/gdrive \
    && mv gdrive/database.dump gdrive/media.tar.gz gdrive/old \
    && docker exec websiteeturkes_db_1 pg_dump -U postgres db > gdrive/database.dump \
    && cd data \
    && sudo tar -zcf ../gdrive/media.tar.gz ./ \
    && cd .. \
    && sudo chown suse1:users gdrive/media.tar.gz \
    && cp -R gdrive/* gdrive/.[!.]* ~/gdrive/Documents/projects/website-eturkes \
    && fusermount -u /var/nocow/$HOME/gdrive
