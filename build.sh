umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install java 8.312.07.1-amzn

mvn install
mvn package

cp target/ichat.jar script/
cp resources/application.yml script/
