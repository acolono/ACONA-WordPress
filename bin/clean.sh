#!/bin/bash

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR=${SCRIPT_DIR}/..

# Remove all Docker containers
cd ${PROJECT_DIR}/docker
echo "If you see an error from the next line you can safely ignore it."
echo "It is because we're trying to take down containers without the .env values for the docker-compose set."
docker-compose down --remove-orphans

# Remove wordpress and composer and npm dependencies
cd ${PROJECT_DIR}
rm -rf wordpress
rm -rf vendor
rm -rf node_modules

# This really only ever needs to be used during development of the boilerplate
# Otherwise you always want to keep those files.
case $1 in
    -a|--all)
        echo -e "${ORANGE}Option '--all' defined. Removing non-default config files.${NC}"
        rm -f data/demo-content.xml
        rm -f docker/.env
        rm -f composer.json
        rm -f composer.lock
        rm -f package.json
        rm -f package-lock.json

        # Since we don't know the name of the plugin file we look for the Plugin header
        find . -maxdepth 1 -type f -name \*.php -exec \
          grep --ignore-case --quiet '* Plugin Name:' {} \; -print0 \
          | xargs -0 --no-run-if-empty rm
esac
