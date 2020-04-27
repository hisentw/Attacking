FROM frolvlad/alpine-java:jre8-slim
WORKDIR /app
RUN mkdir src
RUN mkdir src/main
RUN mkdir src/main/webapp
ADD ./src/main/webapp ./src/main/webapp
ADD ./target/Attacking-*.jar app.jar
ENV TZ Asia/Taipei
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 80