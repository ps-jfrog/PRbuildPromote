#!/usr/bin/env bash
set -euo pipefail

BUILD_NAME="${BUILD_NAME:-prbranch-bpr-app}"
BUILD_ID="${BUILD_ID:-498b9e4}"
BUILD_INFO_FILE="${BUILD_INFO_FILE:-./build-info.json}"

if [[ "${1:-}" == "--use-existing" ]]; then
  shift
  [[ -f "$BUILD_INFO_FILE" ]] || { echo "Missing $BUILD_INFO_FILE (pass path via BUILD_INFO_FILE=...)" >&2; exit 1; }
else
  jf rt curl -sf "api/build/${BUILD_NAME}/${BUILD_ID}" >"$BUILD_INFO_FILE"
fi

echo "Build info: $BUILD_INFO_FILE"
jq -r '.buildInfo.statuses[]? | .status' "$BUILD_INFO_FILE"

echo "| Timestamp (UTC) | Status | User |"
echo "| :------ | :------ | :------ |"

SUMMARY="${GITHUB_STEP_SUMMARY:-}"
while IFS= read -r item; do
  statusVal=$(echo "$item" | jq -r '.status')
  tsVal=$(echo "$item" | jq -r '.timestamp')
  usrVal=$(echo "$item" | jq -r '.user')
  line="| ${tsVal} | ${statusVal} | ${usrVal} |"
  echo "$line"
  if [[ -n "${SUMMARY}" ]]; then
    echo "$line" >>"${SUMMARY}"
  fi
done < <(jq -c '.buildInfo.statuses[]?' "$BUILD_INFO_FILE")

rm -rf ./build-info.json