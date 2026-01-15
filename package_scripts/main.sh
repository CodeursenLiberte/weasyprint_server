#!/bin/bash -x
# Build the package, and run the server in a Docker container

set -o nounset
set -o errexit
set -o pipefail

APP_BRANCH=${1:-main}

./build.sh $APP_BRANCH
./run.sh
