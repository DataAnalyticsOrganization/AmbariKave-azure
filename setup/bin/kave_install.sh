#!/bin/bash
#This is to be executed on the cluster node designated for ambari

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VERSION=${1:-2.0-Beta}
WORKING_DIR=${2:-/root/kavesetup}

wget "https://github.com/KaveIO/AmbariKave/archive/$VERSION.zip" -O "$WORKING_DIR/$VERSION.zip"

unzip "$WORKING_DIR/$VERSION.zip" -d "$WORKING_DIR"

#To avoid conflicts with what the Kave installer installs
yum remove -y epel-release
yum remove -y sshpass pdsh

service iptables stop
chkconfig iptables off
cd "$WORKING_DIR/AmbariKave-$VERSION"
dev/install.sh
dev/patch.sh
ambari-server start
