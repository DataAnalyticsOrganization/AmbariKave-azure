#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

REPOSITORY=$1
USER=$2
PASS=$3
HOSTS=$4
VERSION=$5
KAVE_BLUEPRINT_URL=$6
KAVE_CLUSTER_URL=$7
DESTDIR=${8:-contents}
SWAP_SIZE=${9:-10g}
WORKING_DIR=${10:-/root/kavesetup}

function anynode_setup {
    chmod +x "$DIR/anynode_setup.sh"
    
    "$DIR/anynode_setup.sh" "$REPOSITORY" "$USER" "$PASS" "$DESTDIR" "$SWAP_SIZE" "$WORKING_DIR"
}

function download_blueprint {
    wget -O "$WORKING_DIR/blueprint.json" "$KAVE_BLUEPRINT_URL"

    wget -O "$WORKING_DIR/cluster.json" "$KAVE_CLUSTER_URL"

    KAVE_BLUEPRINT=$(readlink -e "$WORKING_DIR/blueprint.json")

    KAVE_CLUSTER=$(readlink -e "$WORKING_DIR/cluster.json")
}

function distribute_keys {
    $BIN_DIR/distribute_keys.sh "$USER" "$PASS" "$HOSTS"
}

function customize_hosts {
    $BIN_DIR/create_hostsfile.sh "$WORKING_DIR" "$HOSTS"

    pdcp -w "$CSVHOSTS" "$WORKING_DIR/hosts" /etc/hosts
}

function localize_cluster_file {
    $BIN_DIR/localize_cluster_file.sh "$KAVE_CLUSTER"
}

function kave_install {
    $BIN_DIR/kave_install.sh "$VERSION" "$WORKING_DIR"
}

function patch_ipa {
    #Install FreeIPA server and patch it; as this is a regular yum install Ambari will try to reinstall it but it will not be overwritten of course
    yum install -y ipa-server
    
    #Why this? In different parts of the code the common name (CN) is build concatenating the DNS domain name and the string "Certificate Authority", and in our case due to Azure long DNSDN the field ends up to be longer than 64 chars which is the RFC-defined standard maximum. This suffix is added as a naming convention, so we cannot just drop it, rather amend it.

    grep -Ilr "Certificate Authority" /usr/lib/python2.6/site-packages/ipa* | xargs sed -i 's/Certificate Authority/CA/g'
}

function wait_for_ambari {
    cp "$BIN_DIR/../.netrc" ~
    until curl --netrc -fs http://localhost:8080/api/v1/clusters; do
	sleep 1
	echo "Waiting until ambari server is up and running..."
    done
}

function blueprint_deploy {
     $BIN_DIR/blueprint_deploy.sh "$VERSION" "$KAVE_BLUEPRINT" "$KAVE_CLUSTER.local" "$WORKING_DIR"

    # The installation will take quite a while. We'll sleep for a bit before we even start checking the installation status. This lets us be certain that the installation is well under way. 
    sleep 600

    while installation_status && [ "$INSTALLATION_STATUS" = "working" ] ;  do
        echo $INSTALLATION_STATUS
        sleep 5
    done

    if [ "$INSTALLATION_STATUS" = "done" ]; then
       echo "No Criticals detected. The installation appears to be successful!"
    else
       echo "Installation loop broken, installation possibly failed. Exiting."
       exit 255
    fi
}

function installation_status {
    INSTALLATION_STATUS_MESSAGE=$(curl --user admin:admin http://localhost:8080/api/v1/clusters/cluster/?fields=alerts_summary/* 2> /dev/null)
    EXIT_STATUS=$?

    if [ $EXIT_STATUS -ne 0 ]; then
        return $EXIT_STATUS
    else
        if [[ $INSTALLATION_STATUS_MESSAGE =~ "\"CRITICAL\" : 0" ]]; then
            INSTALLATION_STATUS="done"
        else
            INSTALLATION_STATUS="working"
        fi
        return 0
    fi
}




anynode_setup

CSVHOSTS=$(echo "$HOSTS" | tr ' ' ,)

download_blueprint

BIN_DIR=$WORKING_DIR/$DESTDIR/Automation/setup/bin

distribute_keys

customize_hosts

localize_cluster_file

kave_install

patch_ipa

wait_for_ambari

blueprint_deploy
