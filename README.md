# YADDL (Yet Another Docker for Deep Learning) 
## Description

Minimalistic docker environment for running deep learning experiments. It is built on top of nvidia-docker and has tensorflow, keras and pytorch 0.4.0 installed. Furthermore, it automatically runs Tensorboard and Jupyter lab when the container starts. The key feature of this project is a minimal manual configuration (network and folder to save your data).


## Installation 
### Dependencies

* Install latest nvidia drivers
* Install Docker as described in `https://docs.docker.com/install/linux/docker-ce/ubuntu/`. Don't forget to add your username to a group `docker` as follows: `sudo usermod -aG docker $USER`.
* Enable docker to start on boot: `sudo systemctl enable docker`
* Install nvidia-docker as described in `https://github.com/NVIDIA/nvidia-docker`
* Reboot

### Identities

By the default, the docker will import `.gitconfig` from your home directory, however, you can manually place it in the folder. The same goes for the keypairs of the image. By the default the setup script will check if `docker_identity` exists, and if not will create one. To make sure that you can access the running container from the other machines than the current one, you should create your own `authorized_keys`. By the default, the setup script will copy only the default identity `~/.ssh/id_rsa.pub`. If the latter does not exist, it will be created.

To summarize, if you want a predefined docker identity, authorized hosts list and gitconfig, just place the corresponding files into this folder. Do not forget to add your generated `docker_identity.pub` to your GitHub.



## Network settings

If you are running the container within a network behind some firewall with a custom DNS, them you should edit `/etc/docker/daemon.json`. In order to know yoru DNS, you can execute the following command if you use Network Manager:

```
nmcli dev show | grep 'IP4.DNS'
```

Let's say the command has returned you two DNS addresses `x.x.x.x` and `y.y.y.y`. Then the config (given that nvidia-docker is installed) would look like this:

```
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "dns":["x.x.x.x", "y.y.y.y"]
    
}
```

### Building the image

Now, when everything is set, simply run the following:

```
sh set_up.sh
```

## Using the image

To use the pre-built image, run the following command

```
DATADIR=<your directory>sh run_docker.sh
```

After this, your local machine will have the following ports reserved:

* 1231 - SSH
* 1232 - Jupyter lab
* 1233 - Tensorboard

Tensorboard is configured to save the logs into `/data/tb_logs_docker` within your container filesystem. The actual files will eventually be stored in `$DATADIR/tb_logs_docker/`

You can test the connections by typing `ssh root@localhost -p 1231`


### Connecting from a thin client
If you want to connect from a remote machine, you can run SSH tunnels to the host. Furthermore, you will need to manually the lists of accepted identities in  `authorized_keys`. The host machine, where you launch your Docker container, should have the OpenSSH server installed. Then, from a client machine, you can execute the following script:

```
sh connect_container_linux.sh <username> <host address>
```

The same works for Mac:


```
sh connect_container_mac.sh <username> <host address>
```

To execute these scripts you should have `screen` installed. Be careful: these scripts kill all the running screens currently running on the client machine

