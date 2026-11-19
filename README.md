[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/nhost-1?utm_medium=integration&utm_source=button&utm_campaign=nhost)

# Deploy and Host Nhost on Railway

Nhost is an open-source Firebase alternative built on PostgreSQL and GraphQL. It gives your app a Postgres database with an instant GraphQL API (Hasura), user sign-up and sign-in (Nhost Auth), file storage with permissions (Nhost Storage) and a web dashboard to manage tables, users and files.

## About Hosting Nhost

Self-hosting Nhost means running several services that must find each other: Hasura on Postgres, Auth and Storage that register their tables and permissions in Hasura, MinIO as the S3 backend for Storage, and the dashboard with the Hasura CLI migrations API so schema changes are saved. They all share one admin secret and one JWT key. This template wires the eight services over Railway's private network, generates every secret, puts Postgres, MinIO and the migrations folder on volumes, starts each service only after the ones it depends on are healthy, and puts the dashboard behind a login, because the self-hosted dashboard has none of its own.

## Common Use Cases

* Backend for a web or mobile app: sign-up and sign-in, a GraphQL API with row-level permissions, and file uploads
* A self-hosted replacement for Firebase or the Nhost cloud, with your data in your own Postgres
* Internal tools and prototypes that need a database, users and files without writing a backend

## Dependencies for Nhost Hosting

* PostgreSQL (Railway's Postgres service)
* An S3-compatible object store (MinIO, included)

### Deployment Dependencies

* Nhost: https://github.com/nhost/nhost
* Self-hosting guide: https://docs.nhost.io/platform/self-hosting
* Hasura GraphQL Engine: https://hasura.io/docs/2.0/index/
* Template source: https://github.com/aalfath/nhost-railway-template

### Implementation Details

The template deploys these services:

* **Postgres**: Railway's PostgreSQL with a volume. Holds your data plus the `auth` and `storage` schemas.
* **Hasura** (public): GraphQL Engine v2.50.3 (Nhost build). GraphQL at `https://YOUR-HASURA-DOMAIN/v1/graphql`. Creates the schemas and extensions Auth and Storage need before it starts.
* **Auth** (public): Nhost Auth 0.53.0 at `https://YOUR-AUTH-DOMAIN/v1`. Email and password sign-up works out of the box; email verification is off until you add SMTP.
* **Storage** (public): Nhost Storage 0.15.1 at `https://YOUR-STORAGE-DOMAIN/v1`, using the `nhost` bucket in MinIO.
* **MinIO** (private): S3 store for uploaded files, on a volume at `/data`.
* **Hasura CLI** (private): the migrations API the dashboard uses to save schema changes, with migrations and metadata on a volume at `/app/data`.
* **Dashboard Web** (private): the Nhost dashboard 3.10.1.
* **Dashboard** (public): a Caddy login gateway in front of the dashboard and the migrations API. Only `/healthz` is open.

**After deploy:** open the Dashboard service's domain and log in as `admin` with the `DASHBOARD_PASSWORD` from the Dashboard service's Variables tab. The Hasura admin secret is `HASURA_GRAPHQL_ADMIN_SECRET` on the Hasura service; keep it private, it bypasses all permissions. Point the Nhost SDK at your own endpoints:

```js
import { createClient } from "@nhost/nhost-js";
const nhost = createClient({
  authUrl: "https://YOUR-AUTH-DOMAIN/v1",
  graphqlUrl: "https://YOUR-HASURA-DOMAIN/v1/graphql",
  storageUrl: "https://YOUR-STORAGE-DOMAIN/v1",
});
```

**Optional settings** (add them as variables on the Auth service): `AUTH_CLIENT_URL` (your frontend URL, used in email links), `AUTH_SMTP_HOST`, `AUTH_SMTP_PORT`, `AUTH_SMTP_USER`, `AUTH_SMTP_PASS`, `AUTH_SMTP_SENDER` and `AUTH_EMAIL_SIGNIN_EMAIL_VERIFIED_REQUIRED=true` to require verified emails, plus the `AUTH_PROVIDER_*` variables for OAuth providers.

**Not included:** Nhost Functions (it needs your own function code) and the Mailhog/Mailpit mail catcher (development only).

**Updates:** every service except Postgres builds from the public repo `aalfath/nhost-railway-template`, with each upstream image pinned by version and digest. When we bump a version, Railway shows you an update notice and you choose when to apply it. Read `CHANGELOG.md` in the repo first; breaking changes are listed at the top of each entry.

## Why Deploy Nhost on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Nhost on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
