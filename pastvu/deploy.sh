#!/usr/bin/env -S -i bash
set -exu
shopt -s expand_aliases
source ./share/eslint.subr
source ./share/aliases
source ~/env/pastvu.env

NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
# Pastvu config
export PROTOCOL
export DOMAIN
export CONFIG=./config/$PASTVU_ENV.js
export CONFIG_TAG=$(cat $CONFIG|mktag)
export DEPLOY_TAG=$(date|mktag)
export TAG
export EN_TAG

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

set
echo Does environment look reasonable?
echo Enter to proceed, Ctrl+C to cancel.
read

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
