MONGO_PATH=/mnt/mongo/40

sudo mkdir -p $MONGO_PATH

docker volume create -d local \
	-o type=none \
	-o device=$MONGO_PATH \
	-o o=bind \
	pastvu_mongo40

CONTAINER=$(docker run --rm -d -v pastvu_mongo:/data/db pastvu/mongo:3.2.22)
docker exec $CONTAINER mongodump --gzip --db pastvu --archive > /tmp/mongodump.gz
docker stop $CONTAINER

CONTAINER=$(docker run --rm -d -v pastvu_mongo4021:/data/db mongo:4.0.21)
docker exec $CONTAINER mongorestore --gzip --db pastvu --archive < /tmp/mongodump.gz
docker stop $CONTAINER

