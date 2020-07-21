#!/bin/bash

if [ ! -f /initiated ]; then
    echo "Waiting for postgreSQL..."
    while ! nc -z db 5432; do
        sleep 1
    done
    echo "PostgreSQL started"

    python manage.py migrate
    python manage.py clearsessions
    rsync -av --delete --exclude 'media' /tmp/mho-static/ /mho/static
    rm -fr /tmp/mho-static/
    rm -fr /static/CACHE/*
    mkdir -p /mho/static/language
    echo "var MHO_BUILD = '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)';" > /mho/static/components/build.js
    python manage.py shell -c "from language import build; build()"
    python manage.py compress --force
    python manage.py collectstatic --noinput
    touch /initiated
fi

exec "$@"
