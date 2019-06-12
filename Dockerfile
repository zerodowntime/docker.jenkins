##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##


FROM jenkins/jenkins:lts-slim

USER root

RUN apt update \
 && apt install apt-transport-https \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
 && echo 'deb https://download.docker.com/linux/debian stretch stable' >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y \
      docker-ce-cli \
      git \
      make \
      python3 \
      python3-venv \
 && rm -rf /var/lib/apt/lists/*

USER jenkins
