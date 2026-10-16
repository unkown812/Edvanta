#!/bin/sh
# Single-container startup for Render: Spring Boot (internal 8080) + nginx ($PORT).
set -e

export PORT="${PORT:-10000}"
export BACKEND_PORT="${BACKEND_PORT:-8080}"

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
