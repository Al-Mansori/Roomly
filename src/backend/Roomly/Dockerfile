# JDK
FROM openjdk:25-slim
ARG JAR_FILE=target/*.jar
COPY ./target/Roomly-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]