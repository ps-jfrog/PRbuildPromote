#!/bin/bash

# Check if the current branch is dev
if [ "$(git branch --show-current)" != "dev" ]; then
    echo "Error: You are not on the dev branch"
    exit 1
fi

# Check if the test branch exists
if [ -z "$(git branch --list test)" ]; then
    echo "Error: The test branch does not exist"
    exit 1
fi

# Check if the test branch is up to date
if [ -z "$(git diff origin/test)" ]; then
    echo "Error: The test branch is not up to date"
    exit 1
fi
# Checkout Latest
# git pull origin dev
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
git merge --no-ff promote/dev-to-test -m "Promote dev to test"
git push origin test

# Cleanup 
git branch -d promote/dev-to-test
git push origin --delete promote/dev-to-test