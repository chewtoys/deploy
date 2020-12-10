#/bin/bash
. ~/env/production-server.env

docker volume create --driver vieux/sshfs \
  -o sshcmd=$USER@$IP:$STORE_PATH \
  -o ro \
  -o reconnect \
  -o allow_other \
  pastvu_store
