-- Run on every start; every statement is idempotent.
-- Same as upstream examples/docker-compose/initdb.d/0001-create-schema.sql.
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS storage;
-- pgcrypto and citext must live in public for Hasura (hasura/graphql-engine#3657).
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
CREATE OR REPLACE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger LANGUAGE plpgsql AS $$
declare _new record;
begin _new := new;
_new."updated_at" = now();
return _new;
end;
$$;
