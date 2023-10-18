#!/bin/bash

set -euo pipefail

bsp_version="$(cat "$1")"
digest="$(jq -r '."containerimage.digest"' "$2")"
repo="$GITHUB_REPOSITORY"
build="${GITHUB_REF##*/}"
commit="$GITHUB_SHA"
opsdesk_api_client_id="$3"
opsdesk_api_secret="$4"

json="$(jq -cn \
  --arg repository "https://github.com/$repo" \
  --arg build "$build" \
  --arg commit "$commit" \
  --arg dockerDigest "$digest" \
  --arg brightspotVersion "$bsp_version" \
  '$ARGS.named')"

curl -i \
  -X POST \
  --max-time 10 \
  -H "Content-Type: application/json" \
  -H "X-Client-Id: $opsdesk_api_client_id" \
  -H "X-Client-Secret: $opsdesk_api_secret" \
  -d "$json" \
  http://beam-enterprise.opsdesk.space/g/bsp-version/update
