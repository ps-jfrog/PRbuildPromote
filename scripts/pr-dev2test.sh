#!/bin/bash
git pull origin dev
git checkout test

git pull origin test
echo "TEST branch short sha: $(git rev-parse --short origin/test)"
echo "Create PR from dev to test"
# Create Promotion Branch
git checkout -b promote/dev-to-test
# Merge dev into Promotion Branch
git merge dev --no-edit
git push origin promote/dev-to-test

# Merge into test
git checkout test
echo "TEST branch short sha: $(git rev-parse --short origin/test)"

git merge --no-ff promote/dev-to-test -m "Promote dev to test"
git push origin test
echo "MAIN branch short sha: $(git rev-parse --short origin/main)"
echo "TEST branch short sha: $(git rev-parse --short origin/test)"
echo "DEV branch short sha: $(git rev-parse --short origin/dev)"

# Cleanup 
git branch -d promote/dev-to-test
git push origin --delete promote/dev-to-test


