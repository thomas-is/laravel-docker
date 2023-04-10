#!/bin/bash

docker exec -it \
  --user ${1:-$( id -u)} \
  -w /srv \
  laravel \
  sh -l
