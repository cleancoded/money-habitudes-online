#!/bin/bash

mkdir -p ~/mho-backup/

docker exec --user postgres mho-db /usr/bin/pg_dumpall | \
    xz | \
    tee ~/mho-backup/mho-db_$(date "+%Y-%m-%dT%H-%M-%S").sql.xz > /dev/null;

docker cp mho-app:/mho/static/media/ /tmp/mho-media/ && \
    tar cJ -C /tmp/mho-media -f ~/mho-backup/mho-media.tar.xz `ls -A /tmp/mho-media/` && \
    rm -fr /tmp/mho-media*
