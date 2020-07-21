#!/bin/bash

docker-compose pull &&
docker-compose build --pull &&
MHO_DEBUG=${1-False} docker-compose up -d
