# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jre-jammy AS run

WORKDIR /build/backend

EXPOSE 8080

COPY ./target/*.jar /build/backend/tutopedia.jar

ENTRYPOINT [ "java", "-jar", "/build/backend/tutopedia.jar" ]
