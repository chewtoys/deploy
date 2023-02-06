#!/bin/bash
cd $(dirname $0)

. /etc/telelog.subr
. ${PWD}/pastvu.env


# https://stackoverflow.com/questions/3258243/check-if-pull-needed-in-git
git remote update
UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
	echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
	echo "Need to pull"
	git pull && \
	. ${PWD}/pastvu.env && \
	./deploy.sh && \
	telelog "Application synced to version ${VERSION}" || telelog "Failed to sync application version ${VERSION}"
elif [ $REMOTE = $BASE ]; then
	echo "Need to push"
else
	echo "Diverged"
fi
