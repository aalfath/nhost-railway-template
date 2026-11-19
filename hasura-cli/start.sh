#!/bin/sh
# Migrations API for the Nhost dashboard. Private service: the dashboard
# gateway proxies /apis/* to it behind its login.
set -eu
: "${HASURA_GRAPHQL_ENDPOINT:?HASURA_GRAPHQL_ENDPOINT must be set}"
: "${HASURA_GRAPHQL_ADMIN_SECRET:?HASURA_GRAPHQL_ADMIN_SECRET must be set}"
export HOME=/tmp
mkdir -p /app/data/metadata /app/data/migrations

echo "nhost-hasura-cli: waiting for Hasura at $HASURA_GRAPHQL_ENDPOINT"
i=0
until curl -fsS -m 5 -o /dev/null "$HASURA_GRAPHQL_ENDPOINT/healthz"; do
  i=$((i + 1))
  if [ "$i" -ge 150 ]; then
    echo "nhost-hasura-cli: Hasura not reachable after 5 minutes" >&2
    exit 1
  fi
  sleep 2
done

echo "nhost-hasura-cli: starting migrations API on port ${PORT:-9693}"
exec hasura-cli console \
  --no-browser \
  --skip-update-check \
  --endpoint "$HASURA_GRAPHQL_ENDPOINT" \
  --address 0.0.0.0 \
  --console-port 9695 \
  --api-port "${PORT:-9693}" \
  --api-host http://127.0.0.1 \
  --console-hge-endpoint "$HASURA_GRAPHQL_ENDPOINT"
