#!/nhost/busybox sh
# Nhost Storage on Railway: wait for Hasura and MinIO, then start Storage on $PORT.
# Storage creates its tables in the "storage" schema and tracks them in Hasura itself.
set -eu
BB=/nhost/busybox

: "${HASURA_ENDPOINT:?HASURA_ENDPOINT must be set}"
: "${HASURA_GRAPHQL_ADMIN_SECRET:?HASURA_GRAPHQL_ADMIN_SECRET must be set}"
: "${POSTGRES_MIGRATIONS_SOURCE:?POSTGRES_MIGRATIONS_SOURCE must be set}"
: "${S3_ENDPOINT:?S3_ENDPOINT must be set}"
: "${S3_ACCESS_KEY:?S3_ACCESS_KEY must be set}"
: "${S3_SECRET_KEY:?S3_SECRET_KEY must be set}"

export BIND=":${PORT:-5000}"
export API_ROOT_PREFIX="${API_ROOT_PREFIX:-/v1}"
export HASURA_METADATA="${HASURA_METADATA:-1}"
export POSTGRES_MIGRATIONS="${POSTGRES_MIGRATIONS:-1}"
export S3_BUCKET="${S3_BUCKET:-nhost}"
case "$POSTGRES_MIGRATIONS_SOURCE" in
  *sslmode=*) ;;
  *\?*) export POSTGRES_MIGRATIONS_SOURCE="$POSTGRES_MIGRATIONS_SOURCE&sslmode=disable" ;;
  *) export POSTGRES_MIGRATIONS_SOURCE="$POSTGRES_MIGRATIONS_SOURCE?sslmode=disable" ;;
esac

wait_for() {
  name=$1; url=$2; i=0
  echo "nhost-storage: waiting for $name at $url"
  until $BB wget -q -T 5 -O /dev/null "$url" 2>/dev/null; do
    i=$((i + 1))
    if [ "$i" -ge 150 ]; then
      echo "nhost-storage: $name not reachable after 5 minutes" >&2
      exit 1
    fi
    $BB sleep 2
  done
}
wait_for Hasura "${HASURA_ENDPOINT%/v1}/healthz"
wait_for MinIO "${S3_ENDPOINT%/}/minio/health/live"

echo "nhost-storage: starting Storage on $BIND"
exec /bin/storage serve
