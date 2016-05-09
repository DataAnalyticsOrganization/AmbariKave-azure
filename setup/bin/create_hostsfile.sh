#!/bin/bash

WORKING_DIR=${1:-/root/kavesetup}

DOMAIN=`hostname -d`

shift 1

for NODE in $@; do
    lookup_longname=$(getent hosts "$NODE")
    lookups="$lookups"$'\n'"$lookup_longname"$'\t'$NODE
done

echo "$lookups" > "$WORKING_DIR/hosts"
