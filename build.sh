umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install java 8.312.07.1-amzn

mvn install
mvn package

cp target/ichat.jar script/
cp src/main/resources/application.yml script/

cd script
docker-compose up


docker build  -f Dockerfile -t jianboy/ichat:latest . 

docker login --username=jianboy -p xx
docker push jianboy/ichat:latest
docker pull jianboy/ichat:latest


install_online.sh
delete.sh
restart.sh

cd /workspaces/ichat-server ; /usr/bin/env /opt/java/11.0.14/bin/java @/tmp/cp_2m630vzp1wks7eban7u4zqz4h.argfile com.ichat.Application


