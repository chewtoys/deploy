#!/bin/bash
set -x

cd ~/dumps
MONGO_IMAGE=pastvu/mongo:3.2.22
VOLUME=$(ls *.gz|tail -1)
docker volume create $VOLUME
CONTAINER=$(docker run --rm -v $VOLUME:/data/db -d ${MONGO_IMAGE})
sleep 30
docker exec -i $CONTAINER mongorestore --db pastvu --gzip --archive < $VOLUME
docker stop $CONTAINER
echo $VOLUME
