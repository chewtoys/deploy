#!/usr/bin/env -S -i bash
set -exu
shopt -s expand_aliases
alias mktag="shasum|cut -c1-16"
source ~/env/pastvu.env

# Set versions
export TAG="v2.0.3"
export TAG_EN="v2.0.3-en"
export TAG_FILESERVER="master"

case ${NODE_ENV} in
	production)
		;;
	staging)
		;;
	*)
		echo NODE_ENV IS NOT SET
		exit 1
		;;
esac

NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
# Pastvu config
export PROTOCOL
export DOMAIN
export NODE_ENV
export CONFIG=./config/${NODE_ENV}.js
export CONFIG_TAG=$(cat ${CONFIG}|mktag)
export DEPLOY_TAG=$(date|mktag)

# Pull images to reduce number of Dockerhub hits
for t in $TAG $TAG_EN; do
	docker pull ghcr.io/pastvu/backend:$t
	docker pull ghcr.io/pastvu/frontend:$t
done
docker pull ghcr.io/pastvu/fileserver:$TAG_FILESERVER


# Do the job
docker node update --label-add pastvu.pastvu-data=true ${NODE_ID}
docker stack deploy \
	--with-registry-auth \
	--prune \
	-c pastvu.yml \
	-c routing.yml \
	-c ${NODE_ENV}.yml \
	pastvu
