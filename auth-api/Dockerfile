# syntax=docker/dockerfile:1

# ---------- build ----------
FROM golang:1.18-alpine AS build
WORKDIR /src
RUN apk add --no-cache git

# Copiamos el código
COPY . .

# Forzamos módulos; si no hay go.mod, lo inicializamos
ENV GO111MODULE=on
RUN [ -f go.mod ] || go mod init auth-api
RUN go mod tidy

# Compilación estática
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/auth-api

# ---------- runtime ----------
FROM alpine:3.20
WORKDIR /app
COPY --from=build /out/auth-api /app/auth-api

# Variables útiles (ajustables en compose)
ENV AUTH_API_PORT=8000 \
    USERS_API_ADDRESS=http://users-api:8083 \
    JWT_SECRET=PRFT \
    ZIPKIN_URL=http://zipkin:9411 \
    ZIPKIN_ENDPOINT=http://zipkin:9411/api/v2/spans \
    SERVICE_NAME=auth-api

EXPOSE 8000
ENTRYPOINT ["/app/auth-api"]
