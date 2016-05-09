#!/bin/bash

USER=$1 
PASS=$2

shift 2

key=/root/.ssh/id_rsa

ssh-keygen -f "$key" -t rsa -N ''

echo StrictHostKeyChecking$'\t'no > ~/.ssh/config 

for NODE in $@; do
    sshpass -p "$PASS" ssh-copy-id -i "$key" root@"$NODE"
done
