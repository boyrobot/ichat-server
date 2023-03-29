FROM openjdk:8-jdk-slim
MAINTAINER glw
ENV JAVA_OPTIONS -Xmx768m
ARG INSTALL_DIR=/data/apps
ADD ./*.jar ${INSTALL_DIR}/ichat.jar
COPY ./*.yml ${INSTALL_DIR}/config/

WORKDIR ${INSTALL_DIR}
EXPOSE 8080
CMD java $JAVA_OPTIONS -jar /data/apps/ichat.jar -Dspring.config.location=/data/apps/config/
