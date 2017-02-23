#!/bin/bash
set -xeuo pipefail

# Mount tempoary EBS storage
sudo mkfs.ext4 /dev/xvdb
sudo mount /dev/xvdb /mnt

# Install crystal repositories
sudo apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list

# Install build deps, crystal and required development libraries
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y \
    openjdk-7-jre-headless ca-certificates-java crystal build-essential curl wget \
    libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev llvm-dev \
    libreadline-dev libbsd-dev libedit-dev libpcre3-dev git automake libtool \
    pkg-config ca-certificates
sudo apt-get -t jessie-backports install -y cmake
sudo rm -rf /var/lib/apt/lists/*

build_llvm() {
    local llvm_ver=$1

    mkdir -p /mnt/llvm/$llvm_ver/build

    (
        cd /mnt/llvm
        curl http://releases.llvm.org/$llvm_ver/llvm-$llvm_ver.src.tar.xz | tar -xJ
        mv llvm-$llvm_ver.src /mnt/llvm/$llvm_ver/src

        cd /mnt/llvm/$llvm_ver/build
        cmake -DCMAKE_INSTALL_PREFIX=/opt/llvm/$llvm_ver/ ../src
        cmake --build . --clean-first -- -j4
        sudo cmake --build . --target install
    )

    rm -Rf /mnt/llvm/$llvm_ver
}

# Create llvm build workdir
sudo mkdir /mnt/llvm
sudo chown admin:admin /mnt/llvm

build_llvm 3.9.1
build_llvm 3.8.1
build_llvm 3.5.2

# Compile and install bdwgc
sudo mkdir /mnt/build
sudo chown admin:admin /mnt/build
(
    cd /mnt/build

    git clone https://github.com/ivmai/bdwgc.git
    cd bdwgc
    git clone https://github.com/ivmai/libatomic_ops.git

    (pkg-config || true)
    autoreconf -vif
    automake --add-missing
    ./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
    make
    make check
    sudo make install
)

# Create jenkins workdir
sudo mkdir /opt/jenkins
sudo chown admin:admin /opt/jenkins
