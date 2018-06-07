# Builds docker container for Deep Learning

## Installation process for Ubuntu 16.04 LTS

### Dependencies

* Install latest nvidia drivers
* Install Docker as described in `https://docs.docker.com/install/linux/docker-ce/ubuntu/`. Don't forget to add your username to a group `docker` as follows: `sudo usermod -aG docker $USER`.
* Enable docker to start on boot: `sudo systemctl enable docker`
* Install nvidia-docker as described in `https://github.com/NVIDIA/nvidia-docker`

### Identities

By the default, the docker will import `.gitconfig` from your home directory, however, you can manually place it in the folder. The same goes for the keypairs of the image. By the default the setup script will check if `docker_identity` exists, and if not will create one. To make sure that you can access the running container from the other machines than the current one, you should create your own `authorized_keys`. By the default, the setup script will copy only the default identity `~/.ssh/id_rsa.pub`. If the latter does not exist, it will be created.

To summarize, if you want a predefined docker identity, authorized hosts list and gitconfig, just place the corresponding files into this folder. 

### Building the image

Now, when everything is set, simply run the following:

```
sh set_up.sh

```

## Configuring the image

If you are running the container within a network with a different DNS than 8.8.8.8, then you need to edit `run_docker.sh` and change the variable `$DNS`. You can see the DNS settings which are applied to your interface as follows:
```
nmcli -t -f IP4.DNS device show <your interface>

```

Another important option is the folder to store yoru data (by the default it will be erased when you restart the container). Set the variable `$DATADIR`.

## Using the image

To use the pre-built image, run the following command

```
sh run_docker.sh

```

After this, your local machine will have the following ports reserved:

* 1231 - SSH
* 1232 - Jupyter lab
* 1233 - Tensorboard


You can test the connections by typing `ssh root@localhost -p 1231`

