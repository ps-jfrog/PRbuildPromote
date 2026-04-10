#!/bin/bash
arg=${1:-"dev"}

arg=$(echo "${arg}" | tr '[:lower:]' '[:upper:]' | xargs)
case "${arg}" in
  DEV)
    git checkout dev
    git pull origin dev
    ;;
  TEST|TST)
    git checkout test
    git pull origin test
    ;;
  PROD|PRD)
    git checkout main
    git pull origin main
    ;;
  *)
    echo "Error: Invalid argument."
    exit 1
    ;;
esac

echo "now, the current branch is ${arg}"