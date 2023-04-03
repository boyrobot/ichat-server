FROM openjdk:8-jdk-slim

ENV JAVA_OPTIONS -Xmx768m
ARG INSTALL_DIR=/data/apps
WORKDIR ${INSTALL_DIR}
ADD ./*.jar ${INSTALL_DIR}/ichat.jar
COPY ./application.yml ${INSTALL_DIR}/config/

EXPOSE 8080 8088

CMD java $JAVA_OPTIONS -jar /data/apps/ichat.jar -Dspring.config.location=/data/apps/config/
