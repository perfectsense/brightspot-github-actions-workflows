#!/bin/bash

set -euo pipefail

bsp_version="$(cat "$1")"
digest="$(jq -r '."containerimage.digest"' "$2")"
repo="$GITHUB_REPOSITORY"
build="${GITHUB_REF##*/}"
commit="$GITHUB_SHA"

json="$(jq -cn \
  --arg repository "https://github.com/$repo" \
  --arg build "$build" \
  --arg commit "$commit" \
  --arg dockerDigest "$digest" \
  --arg brightspotVersion "$bsp_version" \
  '$ARGS.named')"

aws sqs send-message \
  --queue-url 'https://sqs.us-east-1.amazonaws.com/242040583208/example-bsp-version-queue.fifo' \
  --message-body "$json"

