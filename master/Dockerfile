FROM jenkins:2.19.4-alpine

COPY ref/init.groovy.d/executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
RUN install-plugins.sh git:3.0.1 blueocean:1.0.0-b13 ansicolor:0.4.3 \
    workflow-aggregator:2.4 pipeline-stage-view:2.4 cloudbees-folder:5.14 \
 && echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
