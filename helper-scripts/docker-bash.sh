#!/bin/sh
# Enter web container using Bash

docker-compose run --rm --service-ports web bash
