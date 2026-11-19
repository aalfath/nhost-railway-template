#!/bin/sh
set -eu
: "${DASHBOARD_PASSWORD:?DASHBOARD_PASSWORD must be set}"
: "${DASHBOARD_UPSTREAM:?DASHBOARD_UPSTREAM must be set}"
: "${HASURA_CLI_UPSTREAM:?HASURA_CLI_UPSTREAM must be set}"
export PORT="${PORT:-8080}"
export DASHBOARD_USERNAME="${DASHBOARD_USERNAME:-admin}"
DASHBOARD_PASSWORD_HASH="$(caddy hash-password --plaintext "$DASHBOARD_PASSWORD")"
export DASHBOARD_PASSWORD_HASH
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
