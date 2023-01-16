#!/bin/sh
set -e

# Create root folder with one additional directory that will act as a bucket
mkdir -p /data/quickwit/indexes
mkdir -p /data/clickhouse/logs

# Run original command
exec minio "$@"
