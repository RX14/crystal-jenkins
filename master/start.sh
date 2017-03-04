#!/bin/bash
set -euo pipefail
docker stop crystal-jenkins-master || true
docker rm crystal-jenkins-master || true

rm -Rf `pwd`/data/plugins || true
mkdir `pwd`/data || true
chown -R 1000:1000 `pwd`/data

docker run -d \
       --name=crystal-jenkins-master \
       --restart=always \
       -p 127.0.0.1:8080:8080 \
       -p 50000:50000 \
       -v `pwd`/data:/var/jenkins_home \
       crystal-jenkins-master
