#!/bin/bash
# Exit on any error
set -e

# Setup colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

function await_database_connections() {
    for i in {1..15}
    do
        if wp db check --silent >/dev/null 2>&1
        then
            echo -e "${GREEN}DB ready.${NC}"
            break
        fi

        if test $i -eq 1
        then
            echo -e "${GREEN}Waiting for up to 15 seconds for DB to be ready.${NC}"
        fi

        sleep 1
        echo -n "."

        if test $i -eq 15
        then
            echo -e " ${RED}Timed out waiting for database.${NC}"
            exit 1
        fi
    done
}

# Only bootstrap if apache is launched
if [[ "$1" == apache2* ]] ; then

  # This is sneaky. By using -v it still triggers the if in docker-entrypoint.sh, downloading WP but doesn't start apache
  docker-entrypoint.sh apache2 -v > /dev/null

  # Wait for DB to be ready
  await_database_connections

  # Bootstrap the site if not installed yet
  if ! wp core is-installed;
  then
      wp core install \
        --title="${COMPOSE_PROJECT_NAME}" \
        --admin_user="wp" \
        --admin_password="wp" \
        --url="${SOLUM_DOMAIN}:${SOLUM_PORT_WEB}" \
        --admin_email="wp@local.test" \
        --skip-email
      wp plugin activate "${COMPOSE_PROJECT_NAME}"
      wp option update permalink_structure "/%postname%/" --quiet
      wp rewrite flush --hard  --quiet

      if [ -f /var/www/html/wp-content/plugins/${COMPOSE_PROJECT_NAME}/data/demo-content.xml ]; then
        echo -e "${GREEN}---------------------------------- ${NC}"
        echo -e "${GREEN} Demo content found. Importing it. ${NC}"
        echo -e "${GREEN}-----------------------------------${NC}"
        wp plugin install wordpress-importer --activate
        wp import /var/www/html/wp-content/plugins/${COMPOSE_PROJECT_NAME}/data/demo-content.xml --authors=create
      fi

  fi
fi

cd /var/www/html/wp-content/plugins/${COMPOSE_PROJECT_NAME}

exec "$@"