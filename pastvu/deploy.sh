#!/bin/bash
set -exu
. share/eslint.subr

cat ~/env/pastvu.env
echo Does environment look reasonable?
echo Enter to proceed, Ctrl+C to cancel.
read
source ~/env/pastvu.env

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
export CONFIG_TAG=$(shasum $CONFIG|cut -c1-16)
export DEPLOY_TAG=$(date|shasum|cut -c1-16)

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
