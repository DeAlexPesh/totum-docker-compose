#!/usr/bin/env bash
set -e
psql -v ON_ERROR_STOP=1 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" \
 -c "CREATE SCHEMA IF NOT EXISTS ${POSTGRES_DB_SCHEME};"