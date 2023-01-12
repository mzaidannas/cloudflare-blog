#!/bin/sh
set -e

# Create logs index if it doesn't exist
quickwit index create --index-config /quickwit/index-config.yaml || true

# Run quickwit server
quickwit run
