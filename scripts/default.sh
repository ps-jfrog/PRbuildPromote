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
printf "    **** DEV BUILD STATUS ****"
printf "\n--------------------------------\n"
BUILD_INFO_DEV="./dev-build-info.json"
jf rt curl -sf "api/build/${BUILD_NAME}/${DEV_SHORT_SHA}" > $BUILD_INFO_DEV
if [ ! -s $BUILD_INFO_DEV ]; then
    echo "DEV BUILD NOT FOUND"
else
  jq -r '.buildInfo.statuses[]? | .status' "$BUILD_INFO_DEV"
  while IFS= read -r item; do
    statusVal=$(echo "$item" | jq -r '.status')
    tsVal=$(echo "$item" | jq -r '.timestamp')
    usrVal=$(echo "$item" | jq -r '.user')
    printf " - TS: ${tsVal} | STATUS: ${statusVal} | USER: ${usrVal} \n" 
  done < <(jq -c '.buildInfo.statuses[]?' "$BUILD_INFO_DEV")
fi
rm -rf $BUILD_INFO_DEV

printf "\n--------------------------------\n"
printf "    **** TEST BUILD STATUS ****"
printf "\n--------------------------------\n"
BUILD_INFO_TEST="./test-build-info.json"
jf rt curl -sf "api/build/${BUILD_NAME}/${TEST_SHORT_SHA}" > $BUILD_INFO_TEST
if [ ! -s $BUILD_INFO_TEST ]; then
    echo "TEST BUILD NOT FOUND"
else
  jq -r '.buildInfo.statuses[]? | .status' "$BUILD_INFO_TEST"
  while IFS= read -r item; do
    statusVal=$(echo "$item" | jq -r '.status')
    tsVal=$(echo "$item" | jq -r '.timestamp')
    usrVal=$(echo "$item" | jq -r '.user')
    printf " - TS: ${tsVal} | STATUS: ${statusVal} | USER: ${usrVal} \n" 
  done < <(jq -c '.buildInfo.statuses[]?' "$BUILD_INFO_TEST")
fi
rm -rf $BUILD_INFO_TEST

printf "\n--------------------------------\n"
printf "    **** PROD BUILD STATUS ****"
printf "\n--------------------------------\n"
BUILD_INFO_PROD="./prod-build-info.json"
jf rt curl -sf "api/build/${BUILD_NAME}/${PROD_SHORT_SHA}" > $BUILD_INFO_PROD
if [ ! -s $BUILD_INFO_PROD ]; then
    echo "TEST BUILD NOT FOUND"
else
  jq -r '.buildInfo.statuses[]? | .status' "$BUILD_INFO_PROD"
  while IFS= read -r item; do
    statusVal=$(echo "$item" | jq -r '.status')
    tsVal=$(echo "$item" | jq -r '.timestamp')
    usrVal=$(echo "$item" | jq -r '.user')
    printf " - TS: ${tsVal} | STATUS: ${statusVal} | USER: ${usrVal} \n" 
  done < <(jq -c '.buildInfo.statuses[]?' "$BUILD_INFO_PROD")
fi
rm -rf $BUILD_INFO_PROD