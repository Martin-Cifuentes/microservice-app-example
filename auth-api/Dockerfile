FROM golang:1.22 AS builder
WORKDIR /app
COPY . .
RUN go mod init auth-api && go mod tidy
RUN go build -o auth-api .

FROM debian:bullseye-slim
WORKDIR /app
COPY --from=builder /app/auth-api .
CMD ["./auth-api"]
