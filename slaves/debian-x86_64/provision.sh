#!/bin/bash
set -euo pipefail

apt-get update
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list

apt-get update
apt-get dist-upgrade -y
apt-get install -y \
    openjdk-7-jre-headless ca-certificates-java crystal build-essential curl wget \
    libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev llvm-dev \
    libreadline-dev libbsd-dev libedit-dev libpcre3-dev git automake libtool \
    pkg-config ca-certificates
rm -rf /var/lib/apt/lists/*

git clone https://github.com/ivmai/bdwgc.git
cd bdwgc
git clone https://github.com/ivmai/libatomic_ops.git
(pkg-config || true)
autoreconf -vif
automake --add-missing
./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
make
make check
make install
cd ..

wget "$JENKINS_HOST/jnlpJars/slave.jar" -O /home/jenkins/slave.jar

cat <<EOF > /etc/systemd/system/jenkins-slave.service
[Unit]
Description=Jenkins Slave
After=network.target

[Service]
ExecStart=/usr/bin/java -jar /home/jenkins/slave.jar $JENKINS_SLAVE_COMMANDLINE
User=jenkins

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable jenkins-slave
