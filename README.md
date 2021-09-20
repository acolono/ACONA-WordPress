# Acona

## Features

- **Docker based development environment** - Develop and test your plugin with all the tools you need. 
  Do this without messing with your host system or worrying about differing setups when working in a team.
- **Management CLI** - The boilerplate comes with a simple Bash script to initialize, start and clean the 
  development environment.
- **Configure versions** - Change WordPress and PHP versions with ease.  
- **Batteries included** - Apart from WordPress the setup also includes various tools: [WP-CLI](wp-cli.org/),
  [phpMyAdmin](https://www.phpmyadmin.net/), [MailHog](https://github.com/mailhog/MailHog)

## Prerequisites

Currently, the development setup has only been tested with Ubuntu 18.04, but should probably run on other Linux systems and maybe
even a Mac.

Since most things happen inside Docker wrapped by a thin layer of Bash scripting you'll only need:

- [Docker](https://docs.docker.com/v17.09/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)
- bash and common CLI tools like `find`, `grep`, `sed` and `nc` 

## Usage

### 1. Run `./cli.sh init`

This will prepare a new plugin in multiple steps:

1. Create an `.env` file and open it so you can edit it to your liking.
2. If you are starting a project from scratch it will offer you to interactively create a `composer.json`.
3. If you are starting a project from scratch it will offer you to interactively create a `package.json`.
4. It will give you instructions what to add to your `etc/hosts` file.
   (This is intentionally a manual step since messing with it requires `sudo` which we don't ever want to have.)

### 2. Run `./cli.sh start`

This will launch the development environment after doing some basic checks.
(E.g. if you did run `./cli.sh init` before.)

### Clean up

If you want to destroy the development environment and start from scratch run `./cli.sh clean`.
This will *not* remove the configuration created with `./cli.sh init`, so you could run `./cli.sh start` right after.