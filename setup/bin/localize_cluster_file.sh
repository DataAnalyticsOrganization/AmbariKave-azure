#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CLUSTER_FILE=${1:-"$DIR/../../KAVEAzure.cluster.json"}
DOMAIN=`hostname -d`

if [ -f "$CLUSTER_FILE" ]; then
  sed -r s/kave\.io/$DOMAIN/g "$CLUSTER_FILE" > "$CLUSTER_FILE.local"
else 
  echo "$CLUSTER_FILE does not exist"
fi 
