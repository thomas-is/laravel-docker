#!/bin/bash

docker build -t laravel . || exit 1

echo
echo "starting application"
docker run --rm -it \
  -e LARAVEL_USER=$( id -u) \
  -v $(pwd)/src:/srv \
  -p 8080:80 \
  laravel $@
