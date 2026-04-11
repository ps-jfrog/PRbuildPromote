#!/bin/bash
clear
export DEV_SHORT_SHA=$(git rev-parse --short origin/dev)
echo "DEV SHORT SHA: $DEV_SHORT_SHA"
export TEST_SHORT_SHA=$(git rev-parse --short origin/test)
echo "TEST SHORT SHA: $TEST_SHORT_SHA"
export PROD_SHORT_SHA=$(git rev-parse --short origin/main)
echo "PROD SHORT SHA: $PROD_SHORT_SHA"

BUILD_NAME="prbranch-bpr-app"
printf "\n--------------------------------\n"
printf "    **** BUILD STATUS ****"
printf "\n--------------------------------\n"
BUILD_INFO="./dev-build-info.json"
jf rt curl -sf "api/build/${BUILD_NAME}/${DEV_SHORT_SHA}" > $BUILD_INFO
if [ ! -s $BUILD_INFO ]; then
    echo "DEV BUILD NOT FOUND"
else
  jq -r '.buildInfo.statuses[]? | .status' "$BUILD_INFO"
  while IFS= read -r item; do
    statusVal=$(echo "$item" | jq -r '.status')
    tsVal=$(echo "$item" | jq -r '.timestamp')
    usrVal=$(echo "$item" | jq -r '.user')
    printf " - TS: ${tsVal} | STATUS: ${statusVal} | USER: ${usrVal} \n" 
  done < <(jq -c '.buildInfo.statuses[]?' "$BUILD_INFO")
fi
rm -rf $BUILD_INFO
