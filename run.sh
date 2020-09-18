#!/bin/bash
NAME=mylovelyjenkins
VOLUME=/Users/$USER/tmp/jenkins
JENKINS_HOME=/var/jenkins_home
FILE=.jenkins_docker_credentials

if [ "$(uname)" = "Linux" ]; then
    USER_ID=$(id -u)
    USER_GROUP_ID=$(id -g)
    DOCKER_SOCKET_GROUP_ID=$(stat -c "%g" /var/run/docker.sock)

    docker run --detach \
        -v ${VOLUME}:${JENKINS_HOME} \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$(pwd)/${FILE}":${JENKINS_HOME}/${FILE} \
        -u ${USER_ID}:${USER_GROUP_ID} \
        --group-add $DOCKER_SOCKET_GROUP_ID \
        -e ADMIN_PASSWORD_FILE=${JENKINS_HOME}/${FILE} \
        --name $NAME \
        -p 8080:8080 zdt.jenkins:test
elif [ "$(uname)" = "Darwin" ]; then
    docker run --detach \
        -v ${VOLUME}:${JENKINS_HOME} \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$(pwd)/${FILE}":${JENKINS_HOME}/${FILE} \
        -e ADMIN_PASSWORD_FILE=${JENKINS_HOME}/${FILE} \
        --name $NAME \
        -p 8080:8080 zdt.jenkins:test
else
    echo "not supported platform"
    return 1
fi


echo "docker logs -t mylovelyjenkins"
