# Hasura GraphQL Engine, Nhost build (the version the Nhost stack pins).
FROM nhost/graphql-engine:v2.50.3-ce@sha256:e309a38bc8006754f8fd61b895039bdcf0449b4c163244e220ff901588758dfa
COPY init.sql /nhost/init.sql
COPY start.sh /nhost/start.sh
ENTRYPOINT ["/bin/sh", "/nhost/start.sh"]
