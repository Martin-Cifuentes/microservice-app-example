# Etapa de build
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Etapa de runtime
FROM openjdk:8-jdk-slim
WORKDIR /app
COPY . .
RUN chmod +x mvnw && ./mvnw clean package -DskipTests
CMD ["java", "-jar", "target/users-api-0.0.1-SNAPSHOT.jar"]
