#!/bin/bash -x
# Install the .deb in a Docker container, and run the server

set -o nounset
set -o errexit
set -o pipefail

BASE_URL="http://$(ip -4 -br addr show wlan0 | awk '{print $3}' | cut -d/ -f1):3000"

# clean
docker container rm -f vanilla || true

# run
docker build -t vanilla -f Dockerfile_vanilla .

docker run -p 8000:8000 -p 9191:9191 -dit --name vanilla vanilla:latest /bin/bash

LAST_DEB=$(find tmp -iname '*.deb' | sort | tail -n 1)
docker cp $LAST_DEB vanilla:/root

docker exec vanilla dpkg -i /root/$(basename $LAST_DEB)

docker exec -u weasyprint vanilla /bin/bash -c "LOG_DIR=/var/log/weasyprint BASE_URL=$BASE_URL UWSGI_HTTP_SOCKET=0.0.0.0:8000 UWSGI_STATS=0.0.0.0:9191 UWSGI_PROCESSES=4 UWSGI_ENABLE_THREADS=true UWSGI_MODULE=wsgi:app UWSGI_CHDIR=/opt/weasyprint/app /opt/weasyprint/app/.venv/bin/uwsgi"
