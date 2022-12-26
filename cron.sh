#!/bin/bash
. /etc/telelog.subr

cd $(dirname $0)

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
	./deploy.sh && \
	telelog "Application synced" || telelog "Failed to sync application"
elif [ $REMOTE = $BASE ]; then
	echo "Need to push"
else
	echo "Diverged"
fi
