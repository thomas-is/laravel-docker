#!/bin/bash

docker build -t laravel ./docker || exit 1

echo
echo "starting application"
docker run --rm -it \
  --name laravel \
  -e LARAVEL_USER=$( id -u) \
  -v $(pwd)/src:/srv \
  -p 8080:80 \
  -p 5173:5173 \
  laravel $@
