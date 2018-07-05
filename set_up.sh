#!/bin/bash

# Copying the git settings
cp ~/.gitconfig gitconfig

# Generating identity keys
if [ ! -f docker_identity ]; then
    echo "==> Generating docker identity"
    ssh-keygen -t rsa -f docker_identity -q -N ""
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R [localhost]:1231
fi

# Checking the authorized keys
if [ ! -f authorized_keys ]; then
    # Checking if the user has identity
    if [ ! -f $HOME/.ssh/id_rsa.pub ]; then
        echo "==> User identity does not exist! Generating..."
        ssh-keygen -t rsa -q -N ""
    fi

    # Creating the *authorized keys*
    echo "==> Making the user to be authorized to login into the image"
    cat $HOME/.ssh/id_rsa.pub > authorized_keys
    echo "\n" >> authorized_keys

fi

ssh-keygen -f "$HOME/.ssh/known_hosts" -R [localhost]:1231

# Building the Docker image
docker build --build-arg HOST_USER=$USER -t deep_docker .
