# Builds docker container for Deep Learning

# Installation process for Ubuntu 16.04 LTS

## Dependencies
* Install latest nvidia drivers
* Install Docker as described in `https://docs.docker.com/install/linux/docker-ce/ubuntu/`. Don't forget to add your username to a group `docker` as follows: `sudo usermod -aG docker $USER`.
* Enable docker to start on boot: `sudo systemctl enable docker`
* Install nvidia-docker as described in `https://github.com/NVIDIA/nvidia-docker`

## Building the container

Now, when everything is set, simply run the following:

```
docker build -t deep_docker .
```

# Using the image

To use the pre-built image, run the following command

```
DATADIR=<your folder with data> sh run_docker.sh
```

After this, your local machine will have the following ports reserved:

* 1231 - SSH
* 1232 - Jupyter lab
* 1233 - Tensorboard