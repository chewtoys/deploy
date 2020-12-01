#!/bin/bash
. ~/env/production-server.env
P=$USER@$IP
FILE=$(ssh $P find $MONGO_BACKUPS_PATH|sort|tail -1)
mkdir -p ~/dumps
scp $P:$FILE ~/dumps
