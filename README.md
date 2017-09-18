# docker-alpine-wildfly8.x
docker image for wildfly 8.x based on alpine linux

Commandline using docker command:

build:

    docker build -t alpine-wildfly8.x .

debug:

    docker run -i -t --entrypoint=sh alpine-wildfly8.x

run:

You can use the **docker** commands below or just trigger **docker-compose**:

    USER_ID=`id -u` docker-compose up -d

or the **docker** commmand:

    docker run -d -p 18080:8080 -p 19990:9990 -u `id -u` -v ~/git/docker-alpine-wildfly8.x/deployments:/opt/jboss/wildfly/standalone/deployments -v ~/git/docker-alpine-wildfly8.x/log:/opt/jboss/wildfly/standalone/log --name wildfly8.x-instance alpine-wildfly8.x

after that use 'docker logs -f wildfly8.x-instance'


login:

    docker exec -i -t -u jboss wildfly8.x-instance /bin/sh

logout:

    exit

for testing use this repo:

    https://github.com/xcoulon/wildfly-quickstart/tree/master/helloworld

    mvn clean package wildfly:deploy -Dwildfly.hostname=localhost -Dwildfly.port=19990

    curl -viL http://localhost:18080/wildfly-helloworld