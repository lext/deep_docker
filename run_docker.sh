#!/bin/bash

CONTAINER="dl_container_$USER"

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
nvidia-docker run --ipc=host -d -v $DATADIR:/data \
              -P -p 1231:22 -p 1232:8888 -p 1233:6006 \
              --name $CONTAINER deep_docker

# Setting the scripts to setup the environment
docker cp authorized_keys $CONTAINER:$HOME/.ssh/authorized_keys
docker cp docker_identity $CONTAINER:$HOME/.ssh/id_rsa
docker cp docker_identity.pub $CONTAINER:$HOME/.ssh/id_rsa.pub
docker cp run_screens_docker.sh $CONTAINER:$HOME/run_screens_docker.sh
docker cp gitconfig $CONTAINER:$HOME/.gitconfig

docker exec -d $CONTAINER chown -R `id -u`:`id -g` $HOME/
docker exec -d $CONTAINER chmod -R 700 $HOME/
docker exec -d $CONTAINER su - $USER -c "sh $HOME/run_screens_docker.sh"


docker cp authorized_keys $CONTAINER:/root/.ssh/authorized_keys
docker exec -d $CONTAINER chown -R root:root /root
docker exec -d $CONTAINER chmod -R 600 /root 
docker exec -d $CONTAINER systemctl restart ssh

