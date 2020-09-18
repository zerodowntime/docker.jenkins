#!/bin/bash
VOLUME=/Users/$USER/tmp/jenkins
NAME=mylovelyjenkins


docker stop $NAME
docker rm  $NAME
rm -rf $VOLUME
