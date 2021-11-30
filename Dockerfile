FROM maven:3-jdk-11 AS build-stage

ADD . /spring-example-project

WORKDIR /spring-example-project

RUN mvn clean install

FROM openjdk:11-jdk

VOLUME /tmp

WORKDIR /spring-example-project

COPY --from=build-stage "/spring-example-project/target/docker-example-1.1.3.jar" app.jar

EXPOSE 8080

CMD [ "sh", "-c", "java -Dserver.port=$PORT -Xmx300m -Xss512k -XX:CICompilerCount=2 -Dfile.encoding=UTF-8 -XX:+UseContainerSupport -Djava.security.egd=file:/dev/./urandom -jar ./app.jar" ]
