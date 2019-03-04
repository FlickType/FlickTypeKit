#!/bin/sh -e -u -o pipefail
SCRIPT_DIR=`dirname "$0"`
PLATFORM_NAME="$1"
FRAMEWORK_DIR="${SCRIPT_DIR}/../FlickTypeKit.framework"
rm -Rf "${FRAMEWORK_DIR}"
cp -af "${SCRIPT_DIR}/${PLATFORM_NAME}/" "${SCRIPT_DIR}/../"

cat <<EOT > "${FRAMEWORK_DIR}/.gitignore"
*
!.gitignore
EOT
