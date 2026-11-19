# Static busybox gives the Nix-built auth image a shell for the start script.
FROM busybox:1.38.0-musl@sha256:80e38f9a1b39188b8bdb28879178edb322a4402b081a9aedda1924609decd6f6 AS busybox

FROM nhost/auth:0.53.0@sha256:ad63ff4178b9820ab7862e5ec4e710f5cfc36740fb6b7650d8bc02f767e5a51d
COPY --from=busybox /bin/busybox /nhost/busybox
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/nhost/busybox", "sh", "/nhost/start.sh"]
