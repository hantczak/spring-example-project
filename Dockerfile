# Docker multi-stage build

# 1. Building the App with Maven
FROM maven:3-jdk-11 AS build-stage

ADD . /spring-example-project

WORKDIR /spring-example-project

# Just echo so we can see, if everything is there :)
RUN ls -l

# Run Maven build
RUN mvn clean install

RUN cd target && ls -a

# Just using the build artifact and then removing the build-container
FROM openjdk:11-jdk

VOLUME /tmp

WORKDIR /spring-example-project

# Add Spring Boot app.jar to Container
COPY --from=build-stage "/spring-example-project/target/docker-example-1.1.3.jar" app.jar

EXPOSE 8080

# Fire up our Spring Boot app by default
CMD [ "sh", "-c", "java -Dserver.port=$PORT -Xmx300m -Xss512k -XX:CICompilerCount=2 -Dfile.encoding=UTF-8 -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom -jar ./app.jar" ]
