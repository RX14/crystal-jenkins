#!/bin/bash
set -xeuo pipefail

# Install crystal repositories
sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list

# Install LLVM repositories
wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
echo "deb http://apt.llvm.org/jessie/ llvm-toolchain-jessie-3.9 main" | sudo tee /etc/apt/sources.list.d/llvm.list
echo "deb http://apt.llvm.org/jessie/ llvm-toolchain-jessie-4.0 main" | sudo tee -a /etc/apt/sources.list.d/llvm.list

# Upgrade debian
sudo apt-get update
sudo apt-get dist-upgrade -y

# Install dependencies
sudo apt-get install -y \
    openjdk-7-jre-headless \
    git curl wget \
    build-essential pkg-config automake libtool \
    crystal \
    \
    libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev \
    libreadline-dev libbsd-dev libedit-dev libpcre3-dev \
    llvm-3.8-dev llvm-3.9-dev llvm-4.0-dev

sudo rm -rf /var/lib/apt/lists/*

# Compile and install bdwgc
git clone https://github.com/ivmai/bdwgc.git
cd bdwgc
git clone https://github.com/ivmai/libatomic_ops.git

(pkg-config || true)
autoreconf -vif
automake --add-missing
./configure --prefix=/usr --libdir=/usr/lib/i386-linux-gnu
make
make check
sudo make install

cd ..
rm -Rf bdwgc

# Create jenkins workdir
sudo mkdir /opt/jenkins
sudo chown admin:admin /opt/jenkins

# Set up swap
sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152
sudo mkswap /swapfile
echo "/swapfile none swap defaults 0 0" | sudo tee -a /etc/fstab
