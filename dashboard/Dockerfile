# Login gate in front of the Nhost dashboard (which has no login of its own
# when self-hosted) and the hasura-cli migrations API.
FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/bin/sh", "/nhost/start.sh"]
