# Static busybox gives the Nix-built storage image a shell for the start script.
FROM busybox:1.38.0-musl@sha256:80e38f9a1b39188b8bdb28879178edb322a4402b081a9aedda1924609decd6f6 AS busybox

FROM nhost/storage:0.15.1@sha256:cae5ce282b14a1e1f70ee6860858dcb8229e6d977a77ee98b2b08a0c8e6f4759
COPY --from=busybox /bin/busybox /nhost/busybox
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/nhost/busybox", "sh", "/nhost/start.sh"]
