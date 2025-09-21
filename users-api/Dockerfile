FROM maven:3.8.8-eclipse-temurin-8 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Etapa de runtime
FROM openjdk:8-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
