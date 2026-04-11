#!/bin/bash
git pull origin test
echo "TEST branch short sha: $(git rev-parse --short origin/test)"
git checkout main

git pull origin main
echo "MAIN branch short sha: $(git rev-parse --short origin/main)"
echo "Create PR from test to main"
# Create Promotion Branch
git checkout -b promote/test-to-main
# Merge test into Promotion Branch
git merge test --no-edit
git push origin promote/test-to-main

# Merge into main
git checkout main
git merge --no-ff promote/test-to-main -m "Promote test to main"
git push origin main
echo "MAIN branch short sha: $(git rev-parse --short origin/main)"
echo "TEST branch short sha: $(git rev-parse --short origin/test)"
echo "DEV branch short sha: $(git rev-parse --short origin/dev)"
# Cleanup 
git branch -d promote/test-to-main
git push origin --delete promote/test-to-main


