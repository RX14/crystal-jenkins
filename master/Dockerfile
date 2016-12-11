FROM jenkins:2.19.4-alpine

COPY ref/init.groovy.d/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
RUN install-plugins.sh blueocean ansicolor
