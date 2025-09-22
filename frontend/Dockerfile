FROM node:14
WORKDIR /app

# Instala TODAS las dependencias (incluye dev)
COPY package*.json ./
RUN npm install --no-audit --no-fund --loglevel=error

# Código
COPY . .

ENV PORT=8080 \
    AUTH_API_ADDRESS=http://auth-api:8000 \
    TODOS_API_ADDRESS=http://todos-api:8082 \
    ZIPKIN_URL=http://zipkin:9411 \
    ZIPKIN_ENDPOINT=http://zipkin:9411/api/v2/spans \
    SERVICE_NAME=frontend

EXPOSE 8080
# Si tu package.json usa "dev" en lugar de "start", cambia el CMD:
# CMD ["npm","run","dev"]
CMD ["npm","start"]