FROM jenkins:2.32.2-alpine

COPY ref/init.groovy.d/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
RUN install-plugins.sh git:3.0.5 blueocean:1.0.0-b24 ansicolor:0.4.3 \
    workflow-aggregator:2.5 pipeline-stage-view:2.5 cloudbees-folder:5.18 \
    jclouds-jenkins:2.14 \
 && echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
