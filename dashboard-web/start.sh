#!/bin/sh
# The image's own entrypoint writes the NEXT_PUBLIC_* values into the bundle,
# then Next.js listens on $PORT on all IPv4 and IPv6 addresses.
set -eu
: "${NEXT_PUBLIC_NHOST_ADMIN_SECRET:?NEXT_PUBLIC_NHOST_ADMIN_SECRET must be set}"
export PORT="${PORT:-3000}"
export HOSTNAME="::"
exec /nhost-entrypoint.sh /nhost-node /dashboard/server.js
