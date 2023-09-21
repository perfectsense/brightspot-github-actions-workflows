#!/bin/bash

set -euo pipefail

aws sqs send-message \
  --queue-url '' \
  --message-body "$(cat "$1")"

