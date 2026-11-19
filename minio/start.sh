#!/bin/sh
# MinIO for Nhost Storage: data lives on the /data volume.
# Creating the bucket folder before the first start is what upstream does too.
set -eu
: "${MINIO_ROOT_USER:?MINIO_ROOT_USER must be set}"
: "${MINIO_ROOT_PASSWORD:?MINIO_ROOT_PASSWORD must be set}"
mkdir -p "/data/${NHOST_BUCKET:-nhost}"
exec /usr/bin/docker-entrypoint.sh minio server --address ":${PORT:-9000}" /data
