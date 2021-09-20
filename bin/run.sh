#!/bin/bash
# Exit on any error
set -e

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR=${SCRIPT_DIR}/..

cd ${PROJECT_DIR}/docker

docker-compose run --rm "$@"
