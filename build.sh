umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install java 8.312.07.1-amzn

mvn install
mvn package

cp target/ichat.jar script/
cp src/main/resources/application.yml script/

cd script
docker-compose up

install_online.sh
delete.sh
restart.sh