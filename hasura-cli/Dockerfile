# hasura-cli "console" runs the migrations API (/apis/migrate, /apis/metadata)
# that the self-hosted Nhost dashboard uses to save schema changes.
FROM nhost/graphql-engine:v2.50.3-ce.cli-migrations-v3@sha256:656030cfb5518bca20b893f6c65c56d1385c48af3d326231c905eae301ea46d0
WORKDIR /app
COPY config.yaml /app/config.yaml
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/bin/sh", "/nhost/start.sh"]
