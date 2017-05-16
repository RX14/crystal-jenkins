FROM jenkins:2.46.2-alpine

RUN install-plugins.sh git blueocean ansicolor workflow-aggregator \
    pipeline-stage-view cloudbees-folder ec2

COPY ref/init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/

ENV JAVA_OPTS -Djenkins.CLI.disabled=true -Djenkins.install.runSetupWizard=false -Xms512m -Xmx1536m
ENV JENKINS_USER admin
ARG password
ENV JENKINS_PASS $password

