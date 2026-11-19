# Nhost dashboard (Next.js). Private service: reached only through the
# "dashboard" gateway, because its bundle carries the Hasura admin secret.
FROM nhost/dashboard:3.10.1@sha256:ead295e19d22368d11f72de6a12b0d31f0d15492ccb8cc74f439936eb0d5d151
RUN ln -s "$(ls -d /nix/store/*-docker-entrypoint.sh | head -n 1)/bin/docker-entrypoint.sh" /nhost-entrypoint.sh \
 && ln -s "$(ls /nix/store/*-nodejs-*/bin/node | head -n 1)" /nhost-node \
 && test -x /nhost-entrypoint.sh && test -x /nhost-node
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/bin/sh", "/nhost/start.sh"]
