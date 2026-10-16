#!/bin/sh
# Single-container startup for Render: Spring Boot (internal 8080) + nginx ($PORT).
set -e

export PORT="${PORT:-10000}"
export BACKEND_PORT="${BACKEND_PORT:-8080}"

# Wait for MySQL: on Render both services boot together and the DB lags
# behind. Without this the backend crash-loops until Render restarts it.
if [ -n "${DB_URL:-}" ]; then
  DB_HOST=$(printf '%s' "${DB_URL}" | sed -n 's#^[a-zA-Z0-9+:]*://\([^/:?]*\).*#\1#p')
  DB_PORT=$(printf '%s' "${DB_URL}" | sed -n 's#^[a-zA-Z0-9+:]*://[^/:?]*:\([0-9][0-9]*\).*#\1#p')
  DB_HOST="${DB_HOST:-mysql}"
  DB_PORT="${DB_PORT:-3306}"
  echo "Waiting for MySQL at ${DB_HOST}:${DB_PORT} ..."
  TRIES=0
  until mysqladmin --connect-timeout=3 -h "${DB_HOST}" -P "${DB_PORT}" ping 2>/dev/null; do
    TRIES=$((TRIES + 1))
    if [ "${TRIES}" -ge 90 ]; then
      echo "WARNING: MySQL not reachable after ~90s; starting backend anyway."
      break
    fi
    sleep 1
  done
fi

# Inject Render's public $PORT into the nginx template.
# Only these two vars are substituted so $uri/$host tokens survive intact.
envsubst '$PORT $BACKEND_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -t

# Backend on the INTERNAL port only (application.yml reads ${PORT:8080},
# so we pin PORT=8080 for this process and leave $PORT for nginx).
PORT="${BACKEND_PORT}" java ${JAVA_OPTS} -jar /app/app.jar &
BACKEND_PID=$!

nginx -g 'daemon off;' &
NGINX_PID=$!

trap 'kill $BACKEND_PID $NGINX_PID' TERM INT
wait
