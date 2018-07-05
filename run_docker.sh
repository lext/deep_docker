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

# Setting the scripts to setup the environment
docker cp authorized_keys dl_container:/root/.ssh/authorized_keys
docker cp docker_identity dl_container:/root/.ssh/id_rsa
docker cp docker_identity.pub dl_container:/root/.ssh/id_rsa.pub
docker cp run_screens_docker.sh dl_container:/root/run_screens_docker.sh
docker cp gitconfig dl_container:/root/.gitconfig

docker exec -d $CONTAINER chown -R root:root /root
docker exec -d $CONTAINER chmod -R 600 /root 
docker exec -d $CONTAINER systemctl restart ssh
docker exec -d $CONTAINER sh /root/run_screens_docker.sh

