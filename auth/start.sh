#!/nhost/busybox sh
# Nhost Auth on Railway: wait for Hasura, then start Auth on $PORT.
# Auth creates its tables in the "auth" schema and tracks them in Hasura itself.
set -eu
BB=/nhost/busybox

: "${HASURA_GRAPHQL_DATABASE_URL:?HASURA_GRAPHQL_DATABASE_URL must be set}"
: "${HASURA_GRAPHQL_GRAPHQL_URL:?HASURA_GRAPHQL_GRAPHQL_URL must be set}"
: "${HASURA_GRAPHQL_ADMIN_SECRET:?HASURA_GRAPHQL_ADMIN_SECRET must be set}"
: "${HASURA_GRAPHQL_JWT_SECRET:?HASURA_GRAPHQL_JWT_SECRET must be set}"
: "${AUTH_ENCRYPTION_KEY:?AUTH_ENCRYPTION_KEY must be set}"
: "${AUTH_SERVER_URL:?AUTH_SERVER_URL must be set}"

export AUTH_PORT="${PORT:-4000}"
export AUTH_API_PREFIX="${AUTH_API_PREFIX-/v1}"
export POSTGRES_MIGRATIONS_CONNECTION="${POSTGRES_MIGRATIONS_CONNECTION:-$HASURA_GRAPHQL_DATABASE_URL}"
export AUTH_CLIENT_URL="${AUTH_CLIENT_URL:-http://localhost:3000}"
# No SMTP is configured by default, so email verification is off until you add it.
export AUTH_EMAIL_SIGNIN_EMAIL_VERIFIED_REQUIRED="${AUTH_EMAIL_SIGNIN_EMAIL_VERIFIED_REQUIRED:-false}"
export AUTH_EMAIL_TEMPLATES_PATH="${AUTH_EMAIL_TEMPLATES_PATH:-/share/email-templates}"
export AUTH_PASSWORD_MIN_LENGTH="${AUTH_PASSWORD_MIN_LENGTH:-9}"
export AUTH_USER_DEFAULT_ROLE="${AUTH_USER_DEFAULT_ROLE:-user}"
export AUTH_USER_DEFAULT_ALLOWED_ROLES="${AUTH_USER_DEFAULT_ALLOWED_ROLES:-user,me}"
export AUTH_LOCALE_DEFAULT="${AUTH_LOCALE_DEFAULT:-en}"
export AUTH_LOCALE_ALLOWED_LOCALES="${AUTH_LOCALE_ALLOWED_LOCALES:-en}"
export AUTH_GRAVATAR_ENABLED="${AUTH_GRAVATAR_ENABLED:-true}"
export AUTH_GRAVATAR_DEFAULT="${AUTH_GRAVATAR_DEFAULT:-blank}"
export AUTH_GRAVATAR_RATING="${AUTH_GRAVATAR_RATING:-g}"
export AUTH_RATE_LIMIT_ENABLE="${AUTH_RATE_LIMIT_ENABLE:-true}"
export AUTH_RATE_LIMIT_EMAIL_IS_GLOBAL="${AUTH_RATE_LIMIT_EMAIL_IS_GLOBAL:-true}"
export AUTH_SMTP_PORT="${AUTH_SMTP_PORT:-587}"

health="${HASURA_GRAPHQL_GRAPHQL_URL%/v1/graphql}/healthz"
echo "nhost-auth: waiting for Hasura at $health"
i=0
until $BB wget -q -T 5 -O /dev/null "$health" 2>/dev/null; do
  i=$((i + 1))
  if [ "$i" -ge 150 ]; then
    echo "nhost-auth: Hasura not reachable after 5 minutes" >&2
    exit 1
  fi
  $BB sleep 2
done

echo "nhost-auth: starting Auth on port $AUTH_PORT"
exec /bin/auth
