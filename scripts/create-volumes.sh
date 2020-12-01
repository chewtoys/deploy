#!/bin/bash
source ~/env/pastvu.env

docker volume create -d local \
	-o type=none \
	-o device=$STORE_PATH \
	-o o=bind \
	pastvu_store 

docker volume create -d local \
	-o type=none \
	-o device=$MONGO_PATH \
	-o o=bind \
	pastvu_mongo