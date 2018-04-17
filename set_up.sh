# How to run:
#
# 1) Install docker
# 2) check whether DNS is working
# 3) Install Nvidia docker 
#
# Run the script as sh set_up.sh <username> <remoteserver> to build the container and set up certificates
# sh run_docker.sh runs the container with jupyter lab, ssh access and tensorboard
# Password for jupyter is deep_docker
SRV=$2
USR_SRV=$1

# This allows a secure two-way communication between our Docker and remote server

echo "==> Generating the list of authorized keys"
# Copying host pubkey to image
cat /home/$USER/.ssh/id_rsa.pub > authorized_keys
echo "\n" >> authorized_keys
# Copying remote server id to image
ssh $USR_SRV@$SRV 'cat .ssh/authorized_keys' >> authorized_keys

# if we do not have a docker identity generted yet, let's create it
if [ ! -f docker_identity ]; then
    echo "==> Generating docker identity"
    ssh-keygen -t rsa -f docker_identity -q -N ""
    ssh-keygen -f "/home/lext/.ssh/known_hosts" -R [localhost]:1231
fi

# Now we need to allow our Docker a connection to the remote server
# (I usually prohibit the use of password for ssh and rather use (private, public) pairs)
cat docker_identity.pub | ssh $USR_SRV@$SRV 'cat >> .ssh/authorized_keys && echo "Key copied"'

# Building the Docker image
docker build -t deep_docker .


