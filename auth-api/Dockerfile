# Etapa de build
FROM golang:1.25 AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o auth-api .

# Etapa final
FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=builder /app/auth-api .
CMD ["./auth-api"]
