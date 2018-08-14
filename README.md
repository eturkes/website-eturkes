# Steps to Run

* google-drive-ocamlfuse -label eturkes@bu.edu gdrive
* git clone https://github.com/eturkes/website-eturkes.git
* mkdir website-eturkes/binary
* cp -R gdrive/Documents/projects/website-eturkes/* gdrive/Documents/projects/website-eturkes/.[!.]* website-eturkes/binary
* fusermount -u /var/nocow/$HOME/gdrive
* cd website-eturkes
* docker-compose pull
* docker-compose build
* docker-compose up db
* cat binary/database.dump | docker exec -i websiteeturkes_db_1 psql -U postgres db
* docker-compose run web start migrate
* docker-compose run --rm web gulp build
* docker-compose run --rm web python manage.py collectstatic
* sudo tar -zxf binary/media.tar.gz -C data/
* docker-compose up
