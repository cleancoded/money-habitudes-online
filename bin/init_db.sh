#!/bin/bash
docker-compose up -d db
until [ "`docker-compose ps --filter State=Up | grep mho-db`" != "" ]; do sleep 0.1; done
sleep 5
echo "
CREATE USER moneyhabitudes with password 'moneyhabitudes';
CREATE DATABASE moneyhabitudes;
GRANT ALL PRIVILEGES ON DATABASE moneyhabitudes TO moneyhabitudes;
" | docker-compose exec -T -u postgres db psql