#!/bin/bash
branch=${1:-"dev"}

#branch=$(echo "${arg}" | tr '[:lower:]' '[:upper:]' | xargs)
echo "current branch: ${branch}"
# Check if the current branch is dev
branch=$(git branch --show-current | tr '[:lower:]' '[:upper:]' | xargs)
case "${branch}" in
  DEV)
    # Checkout Latest
    git pull origin dev
    git checkout test

    git pull origin test
    echo "Create PR from dev to test"
    # Create Promotion Branch
    git checkout -b promote/dev-to-test
    # Merge dev into Promotion Branch
    git merge dev
    git push origin promote/dev-to-test

    # Merge into test
    git checkout test
    git merge --no-ff promote/dev-to-test -m "no-ff: Promote dev to test"
    git push origin test

    # Cleanup 
    git branch -d promote/dev-to-test
    git push origin --delete promote/dev-to-test
    ;;
  *)
    echo "Error: Invalid argument."
    exit 1
    ;;
esac
