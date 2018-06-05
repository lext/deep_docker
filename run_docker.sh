# Stopping previously ran instances
docker stop dl_container
docker rm dl_container

# Running the new instance
nvidia-docker run --ipc=host -d --mount type=bind,src=$DATADIR,dst=/data -P -p 1231:22 -p 1232:8888 -p 1233:6006  --name dl_container deep_docker
# Running the screens
docker exec -d dl_container sh /root/run_screens.sh

