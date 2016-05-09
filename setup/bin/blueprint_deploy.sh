#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VERSION=${1:-2.0-Beta}
KAVE_BLUEPRINT=${2:-"$DIR/../../../kave_blueprint/KAVEAzure.blueprint.json"}
KAVE_CLUSTER=${3:-"$DIR/../../../kave_blueprint/KAVEAzure.cluster.json.local"}

"$DIR"/../../../AmbariKave-$VERSION/deployment/deploy_from_blueprint.py "$KAVE_BLUEPRINT" "$KAVE_CLUSTER" --verbose --not-strict
