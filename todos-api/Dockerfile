FROM node:14
WORKDIR /app

COPY package*.json ./
RUN npm install --no-audit --no-fund --loglevel=error

COPY . .

ENV TODO_API_PORT=8082 \
    JWT_SECRET=PRFT \
    REDIS_HOST=redis \
    REDIS_PORT=6379 \
    REDIS_CHANNEL=log_channel \
    ZIPKIN_URL=http://zipkin:9411 \
    ZIPKIN_ENDPOINT=http://zipkin:9411/api/v2/spans \
    SERVICE_NAME=todos-api

EXPOSE 8082
CMD ["npm","start"]