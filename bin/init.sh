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

# If the .env file exists the project has already been initialised and we abort.
if [ -f ${PROJECT_DIR}/docker/.env ]; then
  echo -e "${RED}----------------------------------------------${NC}"
  echo -e "${RED} Project has already been initialised. Abort. ${NC}"
  echo -e "${RED} If you want to reset run 'clean.sh' first.   ${NC}"
  echo -e "${RED}----------------------------------------------${NC}"
  exit 1
fi

cd ${PROJECT_DIR}/docker

# Copy .env file from example, open it in nano and load it
cp .env.example .env && nano .env && source .env

# Sanitize project name and abort if it is invalid
PROJECT_NAME=$(echo ${COMPOSE_PROJECT_NAME} | sed -e 's/[^A-Za-z0-9._-]/_/g')
if test $PROJECT_NAME != $COMPOSE_PROJECT_NAME; then
  echo -e "${RED}-------------------------------------------------------------------------${NC}"
  echo -e "${RED} Your project name is invalid. It can only have alphanumeric characters. ${NC}"
  echo -e "${RED}-------------------------------------------------------------------------${NC}"
  exit 1
fi

# Ensure the mount folders exist.
mkdir -p ${PROJECT_DIR}/wordpress/wp-content/plugins/${PROJECT_NAME}

# Build image to ensure any config changes are considered
docker-compose build --pull

# Project bootstrap - Plugin File
if [ ! -f ${PROJECT_DIR}/${PROJECT_NAME}.php ]; then
  printf "<?php\n/**\n* Plugin Name: ${PROJECT_NAME}\n*/" > ${PROJECT_DIR}/${PROJECT_NAME}.php

  # If git is available automatically add the created plugin file.
  if command -v git &> /dev/null
  then
    git add ${PROJECT_DIR}/${PROJECT_NAME}.php
  fi

fi

# Project bootstrap - Composer
if [ ! -f ${PROJECT_DIR}/composer.json ]; then
  echo -e "${GREEN}------------------------------------------------------------------${NC}"
  echo -e "${GREEN} No composer.json found. Do you wish to generate one, if yes how? ${NC}"
  echo -e "${GREEN}------------------------------------------------------------------${NC}"
  select answer in "Yes, interactively." "No"; do
      case $answer in
          "Yes, interactively." )
           docker-compose run --rm wordpress composer init \
            --name "kraftner/${PROJECT_NAME}" \
            --type "wordpress-plugin" \
            --require-dev "inpsyde/php-coding-standards:^1@dev" \
            --stability "dev" \
            --license "GPL-2.0-or-later"
           break;;
          *)
           break;;
      esac
  done
else
  docker-compose run --rm wordpress composer install
fi

# Project bootstrap - Packagist
if [ ! -f ${PROJECT_DIR}/package.json ]; then
  echo -e "${GREEN}------------------------------------------------------------------${NC}"
  echo -e "${GREEN} No package.json found. Do you wish to generate one, if yes how? ${NC}"
  echo -e "${GREEN}------------------------------------------------------------------${NC}"
  select answer in "Yes, interactively." "No"; do
      case $answer in
          "Yes, interactively." )
           docker-compose run --rm build npm init
           docker-compose run --rm build npm install --save-dev --save-exact @wordpress/scripts
           break;;
          *)
           break;;
      esac
  done
else
  docker-compose run --rm build npm install
fi

# Manual instructions to update host file
echo -e "${GREEN}-------------------------------------------------------------${NC}"
echo -e "${GREEN} You should now add this to the end of your /etc/hosts file: ${NC}"
echo -e "${GREEN} #port ${SOLUM_PORT_RANGE_INDEX}x                            ${NC}"
echo -e "${GREEN} 127.0.0.1       ${SOLUM_DOMAIN}                             ${NC}"
echo -e "${GREEN}-------------------------------------------------------------${NC}"
