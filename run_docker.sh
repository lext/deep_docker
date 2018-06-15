#!/bin/bash

CONTAINER="dl_container"

# Stop and kill the container if it is running
if [ "$(docker ps -q -f name=$CONTAINER)" ]; then
    echo "Terminating the container"
    docker stop $CONTAINER
fi
if [ "$(docker ps -aq -f status=exited -f name=$CONTAINER)" ]; then
    echo "Deleting the container"
    docker rm $CONTAINER
fi

# Run the container
nvidia-docker run --ipc=host -d --mount type=bind,src=$DATADIR,dst=/data \
              -P -p 1231:22 -p 1232:8888 -p 1233:6006 \
              --name $CONTAINER deep_docker

docker exec -d $CONTAINER sh /root/run_screens_docker.sh
