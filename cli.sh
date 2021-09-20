#!/bin/bash
# Exit on any error
set -e

case $1 in
   "init")
    ./bin/init.sh
    ;;
   "clean")
    if test "$2" = "--all"
    then
      ./bin/clean.sh --all
    else
      ./bin/clean.sh
    fi
    ;;
   "start")
    ./bin/start.sh
    ;;
   "wp")
    ./bin/run.sh wordpress wp "${@:2}"
    ;;
   "composer")
    ./bin/run.sh wordpress composer "${@:2}"
    ;;
   "npm")
    ./bin/run.sh build npm "${@:2}"
    ;;
   ## This is only really relevant for testing solum.
   "rebuild")
    ./bin/clean.sh --all; ./bin/init.sh; ./bin/start.sh;
    ;;
   *)
    echo "Unknown command."
    exit 1
    ;;
esac
