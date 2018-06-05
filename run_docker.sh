# Stopping previously ran instances
docker stop dl_container
docker rm dl_container

ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R [localhost]:1231

# Running the new instance
nvidia-docker run --ipc=host -d --mount type=bind,src=/media/lext/DATA,dst=/data -P -p 1231:22 -p 1232:8888 -p 1233:6006  --name dl_container deep_docker

docker cp authorized_keys dl_container:/root/.ssh/authorized_keys
docker cp docker_identity dl_container:/root/.ssh/id_rsa
docker cp docker_identity.pub dl_container:/root/.ssh/id_rsa.pub
docker cp run_screens_docker.sh dl_container:/root/run_screens.sh
docker cp kill_screens.sh dl_container:/root/kill_screens.sh
docker cp /home/$USER/.gitconfig dl_container:/root/.gitconfig

docker exec -d dl_container chown -R root:root /root
docker exec -d dl_container chmod -R 600 /root 

docker exec -d dl_container systemctl restart ssh
docker exec -d dl_container sh /root/run_screens.sh

