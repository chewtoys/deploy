#!/usr/bin/env -i bash
set -exu
source ./share/eslint.subr
source ./share/aliases
source ~/env/pastvu.env

set
echo Does environment look reasonable?
echo Enter to proceed, Ctrl+C to cancel.
read

case $PASTVU_ENV in
	staging)
		export MONGO_VOLUME
		export MONGO_IMAGE
		;;
	production)
		;;
	*)
		echo PASTVU_ENV IS NOT SET
		exit 1
		;;
esac

export TAG
export EN_TAG
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')

# Pastvu config
export PROTOCOL
export DOMAIN
export CONFIG=./config/$PASTVU_ENV.js
export CONFIG_TAG=$(echo $CONFIG|mktag)
export DEPLOY_TAG=$(date|mktag)

# Lint config
eslint $CONFIG

# Do the job
docker node update --label-add pastvu.pastvu-data=true $NODE_ID
docker stack deploy \
	--prune \
	-c pastvu.yml \
	-c traefik.yml \
	-c $PASTVU_ENV.yml \
	pastvu
