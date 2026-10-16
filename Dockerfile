# Render single-service Dockerfile — Vite SPA + Spring Boot API in one container.
#
# Render setup (Dashboard -> New -> Web Service -> Docker):
#   Build Context / Dockerfile Path: ./Dockerfile   (repo root, NOT backend/)
#   Plan: Starter or higher (Spring Boot + Node build needs the RAM).
#   Health Check Path: /
#   Environment variables (Dashboard -> Environment):
#     DB_URL          jdbc:mysql://<host>:3306/<db>?createDatabaseIfNotExist=true&useSSL=true&serverTimezone=UTC&allowPublicKeyRetrieval=true
#     DB_USERNAME     <db user>
#     DB_PASSWORD     <db password>            (secret file / env, never commit)
#     JWT_SECRET      <64+ hex chars>           (generate: openssl rand -hex 64)
#     JWT_EXPIRATION  86400000                 (optional, defaults to 24h)
#     VITE_API_BASE_URL  /                     (optional, defaults to same-origin "/")
#   NOTE: Render injects $PORT itself — do NOT set PORT. Nginx listens on $PORT
#   and proxies /api/* to the backend on internal port 8080.
#
# Local build test:
#   docker build -t edvanta .
#   docker run -p 10000:10000 -e PORT=10000 -e DB_URL=... -e DB_USERNAME=... -e DB_PASSWORD=... -e JWT_SECRET=... edvanta

# ---------- Stage 1: build frontend (Vite) ----------
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend

# Install deps first for better layer caching.
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

COPY frontend/ ./
# Same-origin API: frontend calls "/api/v1/..." which nginx proxies to Spring Boot.
# Override at build time if the API lives elsewhere:
#   docker build --build-arg VITE_API_BASE_URL=https://api.example.com .
ARG VITE_API_BASE_URL=/
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
RUN npm run build

# ---------- Stage 2: build backend (Spring Boot) ----------
FROM maven:3.9-eclipse-temurin-21-alpine AS backend-build
WORKDIR /app/backend

# Wrapper + pom first for dependency caching.
COPY backend/pom.xml backend/mvnw backend/mvnw.cmd ./
COPY backend/.mvn ./.mvn
RUN chmod +x mvnw && ./mvnw -B -q dependency:go-offline

COPY backend/src ./src
RUN ./mvnw -B clean package -DskipTests

# ---------- Stage 3: runtime (JRE + nginx) ----------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# nginx serves the SPA; gettext provides envsubst for $PORT injection.
RUN apk add --no-cache nginx gettext \
  && mkdir -p /usr/share/nginx/html /var/log/nginx /var/lib/nginx/tmp \
  && rm -f /etc/nginx/conf.d/default.conf \
  && touch /tmp/nginx.pid

# Backend jar + frontend static assets.
COPY --from=backend-build /app/backend/target/lms-backend-1.0.0.jar /app/app.jar
COPY --from=frontend-build /app/frontend/dist/ /usr/share/nginx/html/

# Nginx template ($PORT/$BACKEND_PORT substituted at startup) + start script.
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Render's $PORT is public (nginx). Backend always uses internal 8080 so the
# two never collide even though application.yml reads ${PORT:8080}.
ENV BACKEND_PORT=8080 \
    JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

EXPOSE 10000

CMD ["sh", "/app/start.sh"]
