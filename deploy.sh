#!/usr/bin/env -S -i bash
set -exu
shopt -s expand_aliases
source ./share/eslint.subr
source ./share/aliases
source ~/env/pastvu.env

TAG="1.3.12"
TAG_EN="${TAG}-en"

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
export TAG
export TAG_EN
export TAG_FILESERVER=1.0.3

echo ================================
env|sort
echo ================================
echo Does environment look reasonable?
echo Enter to proceed, Ctrl+C to cancel.
read

# Lint config
eslint ${CONFIG}

# Do the job
docker node update --label-add pastvu.pastvu-data=true ${NODE_ID}
docker stack deploy \
	--prune \
	-c pastvu.yml \
	-c routing.yml \
	-c ${PASTVU_ENV}.yml \
	-c ${PASTVU_ENV}-scale.yml \
	pastvu
