#!/usr/bin/env bash

set -euo pipefail

TARGET_FILE="$1"
TARGET_FILE_CONTENT="$(cat "$TARGET_FILE")"


# ### Init

SOURCE_FILE_DEV_REPOSITORIES="$(mktemp)"

DEV_PAGE_NAME="Development"

cat >"$SOURCE_FILE_DEV_REPOSITORIES" <<'EOF'
- dockerhub:influxdb:3-core
EOF


# ### Add to "Development" page

YQ_ADD_REPOSITORIES='
  (
    .pages[] | select(.name == "'"$DEV_PAGE_NAME"'").columns[0].widgets[] |
    select(.type == "releases") | .repositories
  ) += load("'"$SOURCE_FILE_DEV_REPOSITORIES"'")
'

# shellcheck disable=2016 # Variables are internal to yq expression
TARGET_FILE_CONTENT="$(yq eval "$YQ_ADD_REPOSITORIES" <<<"$TARGET_FILE_CONTENT")"


# ### Clean Up, Print Result and Exit
rm "$SOURCE_FILE_DEV_REPOSITORIES"

echo "$TARGET_FILE_CONTENT"
exit 0