# ACONA WordPress Integration

ACONA stands for Augmented Content Analytics - an open source tool that automatically analyzes and simplifies data, for example from server logs or existing (open source) analytics tools, and proposes concrete measures for optimizing content.

The CMS integrations (Drupal, WordPress, Neos) create a bridge between the CMS and the ACONA suite. The idea is that scores and recommendations are shown directly there where editors create and maintain content (in the CMS).

More in the general documentation: https://app.gitbook.com/@acolono/s/acona/

## Features
- ACONA Success Scores: With ACONA you can set up page type specific Success Scores (e.g. you can say that for Landingpages a combination of Organic Clicks and a low Bounce Rate defines the score, and for product pages it is just a specific Conversion Rate). In WordPress this ACONA Success Scores will be listed for analyzed URLs in the editor dashboard (currently maximal 5 URLs). 

## Status and roadmap

Currently the WordPress Plugin is a proof of concept and has very limited features. But it will be extended with the following features:
- Analyze more than just 5 URLs (e.g. all URLs from your domain, may require a paid plan for the hosted version)
- History of ACONA Success Scores for every analyzed url
- Show recommendations for every analyzed url, e.g. how content could be improved to get better Success Scores.
- Show notifications and warnings for analyzed URLs, e.g. if a specific metric is much lower/higher than a forecasted value.

# Developing ACONA WordPress integration

The following documentation is about installing and developing the WordPress plugin for ACONA. 

## Included features for development

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

### Exporting plugin

If you want to install the production version the easiest way to export the plugin is this command:

    ./cli.sh wp dist-archive /var/www/html/wp-content/plugins/acona /var/www/html/wp-content/plugins/acona/acona.zip
