FROM python:3.10-slim
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV REDIS_HOST=redis \
    REDIS_PORT=6379 \
    REDIS_CHANNEL=log_channel \
    ZIPKIN_URL=http://zipkin:9411 \
    ZIPKIN_ENDPOINT=http://zipkin:9411/api/v2/spans \
    SERVICE_NAME=log-message-processor

CMD ["python","main.py"]
