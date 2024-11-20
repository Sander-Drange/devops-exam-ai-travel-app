# Build stage
FROM maven:3.8.4-openjdk-11-slim AS builder
WORKDIR /app
COPY java_sqs_client/pom.xml .
COPY java_sqs_client/src ./src
RUN mvn package

# Runtime stage
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=builder /app/target/imagegenerator-0.0.1-SNAPSHOT.jar ./app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]