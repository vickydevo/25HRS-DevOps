FROM maven:3.9.11-eclipse-temurin-21 AS build

WORKDIR /app

LABEL MAINTAINER="VIGNAN" 

COPY . .

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21

WORKDIR /app

COPY --from=build /app/target/gs-spring-boot-0.1.0.jar app.jar

EXPOSE 8081

ENTRYPOINT [ "java" , "-jar", "app.jar" ]