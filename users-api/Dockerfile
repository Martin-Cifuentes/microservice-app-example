# ---------- build ----------
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests

# ---------- runtime ----------
FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=build /workspace/target/*.jar /app/app.jar

ENV SERVER_PORT=8083 \
    JWT_SECRET=PRFT \
    ZIPKIN_URL=http://zipkin:9411 \
    ZIPKIN_ENDPOINT=http://zipkin:9411/api/v2/spans \
    SERVICE_NAME=users-api

EXPOSE 8083
ENTRYPOINT ["java","-jar","/app/app.jar"]
