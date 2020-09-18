##
## authors:
## Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
## Wojciech Polnik <wojciech.polnik@zerodowntime.pl>
##
ARG NUMERIC_VERSION=""

FROM jenkins/jenkins:${NUMERIC_VERSION:-lts-slim}
# https://github.com/jenkinsci/docker/blob/master/README.md

USER root

# ENV JENKINS_USER "admin"
# ENV JENKINS_PASSWORD "admin"

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

# https://github.com/jenkinsci/docker/issues/310
# Disable initial wizard
RUN echo ${NUMERIC_VERSION:-2.0} > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Managing plugins
RUN install-plugins.sh \
  antisamy-markup-formatter matrix-auth \ 
  blueocean \
  configuration-as-code \
  job-dsl
# COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# Script to setting admin account
COPY set_admin_account.groovy /usr/share/jenkins/ref/init.groovy.d/set_admin_account.groovy

USER jenkins
