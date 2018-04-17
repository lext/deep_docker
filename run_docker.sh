# Stopping previously ran instances
docker stop dl_container
docker rm dl_container

ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R [localhost]:1231

# Running the new instance
nvidia-docker run --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --ipc=host -d --mount type=bind,src=/media/lext/FAST/Kaggle,dst=/data -P -p 1231:22 -p 1232:8888 -p 1233:6006  --name dl_container deep_docker

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

echo "Making tunnels through: $1@$2"

sh kill_screens.sh

# SSH
screen -dmS ssh_tunnels && screen -S ssh_tunnel -X stuff "ssh -o \"RSAAuthentication=yes\" -o \"PasswordAuthentication=no\" -R  1231:localhost:1231 $1@$2 > /dev/null 2>&1\n"
# Jupyter lab
screen -dmS jp_tunnel && screen -S jp_tunnel -X stuff "ssh -R  1232:localhost:1232 $1@$2 > /dev/null 2>&1\n"
# Tensorboard
screen -dmS tb_tunnel && screen -S tb_tunnel -X stuff "ssh -R  1233:localhost:1233 $1@$2 > /dev/null 2>&1\n"
