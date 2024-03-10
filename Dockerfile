FROM openjdk:8
EXPOSE 8080
ADD target/DockerExample-1.0.jar .
ENTRYPOINT ["java", "-jar", "/DockerExample-1.0.jar"]