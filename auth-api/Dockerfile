FROM golang:1.25 AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o auth-api .

FROM debian:bullseye-slim
WORKDIR /app
COPY --from=builder /app/auth-api .
CMD ["./auth-api"]
