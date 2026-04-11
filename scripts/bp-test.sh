BUILD_NAME="prbranch-bpr-app"
BUILD_ID=""
DEV_SHA=""
if git rev-parse -q --verify HEAD^2 >/dev/null 2>&1; then
    DEV_SHA="$(git rev-parse HEAD^2)"
    BUILD_ID="$(git rev-parse HEAD^2)"

echo "Dev Short code: ${DEV_SHA}"
echo "BUILD_ID: ${BUILD_ID}"

jf rt curl "/api/build/${BUILD_NAME/${DEV_SHA}"