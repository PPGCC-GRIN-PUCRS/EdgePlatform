# BUILD
FROM gradle:8.10.2-jdk17 AS build

COPY --chown=gradle:gradle api/ /home/gradle/src

WORKDIR /home/gradle/src

RUN gradle build --no-daemon -x test

# ---------
# CONTAINER
FROM openjdk:17

RUN mkdir /app

COPY --from=build /home/gradle/src/build/libs/*.jar /app/api.jar

EXPOSE 8080

ENTRYPOINT ["java", "-XX:-UseContainerSupport", "-XX:+UnlockExperimentalVMOptions",  "-jar",  "/app/api.jar"]
