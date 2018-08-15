# Emir's Personal Website

This is the source code for my website (eturkes.com), which runs on Django CMS. Feel free to use any of the code in your project, just check ACKNOWLEDGEMENTS and LICENSE for copyright info. Included below are the steps for building and backing up the production web server. It makes some assumptions about system configuration, so tailor to your needs. Tested on openSUSE 15.

# Building

1. `google-drive-ocamlfuse -label eturkes@bu.edu ~/gdrive`
   * Database and media are stored in a private Google Drive.
1. `git clone https://github.com/eturkes/website-eturkes.git`
1. `cd website-eturkes`
1. `cp -R ~/gdrive/Documents/projects/website-eturkes binary`
1. `fusermount -u /var/nocow/$HOME/gdrive`
   * fusermount doesn't seem to work with symlinks. Google Drive is mounted here to avoid Btrfs snapshots.
1. `docker-compose pull`
1. `docker-compose build`
1. `docker-compose up -d db`
1. `divio project import db binary/database.dump`
   * Command will fail because the dump is in text format, so for now it is just used to prepare the db container.
1. `cat binary/database.dump | docker exec -i websiteeturkes_db_1 psql -U postgres db`
1. `docker-compose run web start migrate`
1. `docker-compose run --rm web gulp build`
1. `docker-compose run --rm web python manage.py collectstatic`
   * Not needed when running the test server.
1. `sudo tar -zxf binary/media.tar.gz -C data/`
   * Docker assigns root ownership to the data directory.
1. `docker-compose up`

# Backup

1. `google-drive-ocamlfuse -label eturkes@bu.edu ~/gdrive`
1. `mv binary/database.dump binary/media.tar.gz binary/old`
1. `docker exec websiteeturkes_db_1 pg_dump -U postgres db > binary/database.dump`
1. `cd data`
1. `sudo tar -zcf ../binary/media.tar.gz ./`
1. `cd ..`
1. `sudo chown suse1:users binary/media.tar.gz`
1. `cp -R binary/* binary/.[!.]* ~/gdrive/Documents/projects/website-eturkes`
   * Use recursive glob to utilize Google Drive's version control. Works with Bash but not Zsh, have not tested other shells.
1. `fusermount -u /var/nocow/$HOME/gdrive`
