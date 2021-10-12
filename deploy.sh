#!/usr/bin/env -S -i bash
set -exu
shopt -s expand_aliases
source ./share/eslint.subr
source ./share/aliases
source ~/env/pastvu.env

# Set versions
export TAG="1.4.4"
export TAG_EN="1.4.4-en"
export TAG_FILESERVER="1.0.3"

case ${PASTVU_ENV} in
	production)
		;;
	staging)
		;;
	*)
		echo PASTVU_ENV IS NOT SET
		exit 1
		;;
esac

NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
# Pastvu config
export PROTOCOL
export DOMAIN
export CONFIG=./config/${PASTVU_ENV}.js
export CONFIG_TAG=$(cat ${CONFIG}|mktag)
export DEPLOY_TAG=$(date|mktag)

# Lint config
eslint ${CONFIG}

# Do the job
docker node update --label-add pastvu.pastvu-data=true ${NODE_ID}
docker stack deploy \
	--prune \
	-c pastvu.yml \
	-c routing.yml \
	-c ${PASTVU_ENV}.yml \
	pastvu
