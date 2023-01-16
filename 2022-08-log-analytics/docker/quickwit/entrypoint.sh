#!/bin/sh
set -e

# Create Quickwit config file.
echo "version: 0.4
default_index_root_uri: ${S3_PATH}
" > config/quickwit.yaml

# Create logs index if it doesn't exist
quickwit index create --index-config /quickwit/index-config.yaml || true

# Run quickwit server
quickwit run
