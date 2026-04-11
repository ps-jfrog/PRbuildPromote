#!/bin/bash
branch=${1:-"dev"}

#branch=$(echo "${arg}" | tr '[:lower:]' '[:upper:]' | xargs)
# Check if the current branch is dev
branch=$(git branch --show-current | tr '[:lower:]' '[:upper:]' | xargs)
echo "current branch: ${branch}"
case "${branch}" in
  TESTINFO|TEST-INFO)
    echo "Test information"
    git checkout test
    git pull origin test
    git log test --merges --oneline --no-edit
    git log dev --not test --oneline --no-edit
    git merge-base dev test
    ;;
  DEV2)
    echo "Source of truth: dev"
    git checkout dev
    git pull origin dev

    echo "Switch to TEST branch" 
    git checkout test
    git pull origin test

    echo "Merge DEV into TEST"
    git merge dev --no-ff --no-edit -m "Promote dev to test"
    git push origin test

    echo "View merge commit on TEST branch"
    git log test --merges --oneline
    echo "Show DEV commits included in TEST"
    # git log test --not main --oneline
    git log $(git merge-base dev test)..dev --oneline


    echo "DEV commits that are now in TEST"
    git log test..dev --oneline
    echo "Find exact commit lineage base"
    git merge-base dev test
    echo "Get latest DEV commit SHA"
    git rev-parse --short dev

    echo " --- AUDIT ready ----"
    # Show merge commit
    git log test --merges --oneline --no-edit
    git log dev --not test --oneline --no-edit
    git merge-base dev test
    ;;
  DEV)
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
    git merge --no-ff promote/dev-to-test -m "Promote dev to test"
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
