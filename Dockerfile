FROM openjdk:8-jdk-slim
MAINTAINER glw
WORKDIR /data/apps
ENV JAVA_OPTIONS -Xmx768m

ADD ./*.jar ichat.jar
COPY ./*.yml config/

EXPOSE 8080
CMD java $JAVA_OPTIONS -jar /data/apps/ichat.jar -Dspring.config.location=/data/apps/config/
