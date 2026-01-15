#!/bin/bash -x
# Build the .deb package, and put it in `tmp/`

set -o nounset
set -o errexit
set -o pipefail

APP_BRANCH=${1:-main}

# clean
mkdir -p tmp
rm -rf tmp/*
docker container rm -f builder || true

# build
docker build -t package_weasyprint .

docker run -dit --name builder package_weasyprint:latest /bin/bash

# try to simulate gitlab `script` section
# docker exec builder git clone https://github.com/demarches-simplifiees/weasyprint_server.git --branch $APP_BRANCH --single-branch --depth 1
# instead we do this, to avoid cloning the repo every time in development
docker cp ../../weasyprint_server builder:/builds
docker exec builder bash weasyprint_server/package_scripts/package.sh $APP_BRANCH

docker cp builder:$(docker exec builder sh -c 'find $(pwd) -iname weasyprint_server*.deb') tmp
