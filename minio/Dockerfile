# MinIO build that upstream's examples/docker-compose uses for Nhost Storage.
FROM nhost/minio:RELEASE.2025-02-28T09-55-16Z@sha256:a929054ae025fa7997857cd0e2a2e3029238e31ad89877326dc032f4c1a14259
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/bin/sh", "/nhost/start.sh"]
