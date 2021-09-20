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

# If the .env file doesn't exist the project hasn't been initialised yet.
if [ ! -f ${PROJECT_DIR}/docker/.env ]; then
  echo -e "${RED}------------------------------------------${NC}"
  echo -e "${RED} The project hasn't been initialised yet. ${NC}"
  echo -e "${RED} Please run 'init.sh' first.              ${NC}"
  echo -e "${RED}------------------------------------------${NC}"
  exit 1
fi

cd ${PROJECT_DIR}/docker

# Load .env file
source .env

# Check if the domain is set up properly
if ! grep -qE "${SOLUM_DOMAIN}" /etc/hosts; then
  echo -e "${GREEN}----------------------------------------------------------${NC}"
  echo -e "${GREEN} You need to add this to the end of your /etc/hosts file: ${NC}"
  echo -e "${GREEN} #port ${SOLUM_PORT_RANGE_INDEX}x                         ${NC}"
  echo -e "${GREEN} 127.0.0.1       ${SOLUM_DOMAIN}                          ${NC}"
  echo -e "${GREEN}----------------------------------------------------------${NC}"
  exit 1
fi

# Build image to ensure any config changes are considered
docker-compose build > /dev/null

# Start all containers in the background
docker-compose up --detach

echo -e "${GREEN}------------------------------------------------------------------------------${NC}"
echo -en "${GREEN} Waiting for container to boot... Checking ${SOLUM_DOMAIN}:${SOLUM_PORT_WEB}.${NC}"
while ! printf "HEAD / HTTP/1.0\r\n\r\n" | nc -i 1 ${SOLUM_DOMAIN} ${SOLUM_PORT_WEB} 2>&1  | grep -qE "HTTP/1.0 200 OK"; do
  echo -en "${GREEN}.${NC}"
  sleep 1
done
echo ""
echo -e "${GREEN}------------------------------------------------------------------------------${NC}"
echo -e "${GREEN} You can now open the website at${NC}"
echo -e "${GREEN} http://${SOLUM_DOMAIN}:${SOLUM_PORT_WEB}/ ${NC}"
echo -e ""
echo -e "${GREEN} Or you can log in ${NC}"
echo -e "${GREEN}  User: wp  |  Password: wp ${NC}"
echo -e "${GREEN} http://${SOLUM_DOMAIN}:${SOLUM_PORT_WEB}/wp-login.php ${NC}"
echo -e ""
echo -e "${GREEN} Or you can open MailHog at ${NC}"
echo -e "${GREEN} http://${SOLUM_DOMAIN}:${SOLUM_PORT_RANGE_INDEX}5 ${NC}"
echo -e ""
echo -e "${GREEN} Or you can open phpMyAdmin at ${NC}"
echo -e "${GREEN} http://${SOLUM_DOMAIN}:${SOLUM_PORT_RANGE_INDEX}6/db_structure.php?server=1&db=wordpress ${NC}"
echo -e "${GREEN}-------------------------------------------------------------------------------${NC}"
