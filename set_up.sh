# Copying the git settings
cp ~/.gitconfig gitconfig

if [ ! -f docker_identity ]; then
    echo "==> Generating docker identity"
    ssh-keygen -t rsa -f docker_identity -q -N ""
    ssh-keygen -f "/home/lext/.ssh/known_hosts" -R [localhost]:1231
fi

# Checking the authorized keys
if [ ! -f authorized_keys ]; then
    # Checking if the user has identity
    if [ ! -f /home/$USER/.ssh/id_rsa.pub ]; then
        echo "==> User identity does not exist! generating...."
        ssh-keygen -t rsa -q -N ""
    fi
    
    # Creating the *authorized keys*
    echo "==> Making the user to be authorized to login into the"
    cat /home/$USER/.ssh/id_rsa.pub > authorized_keys
    echo "\n" >> authorized_keys

fi

# Building the Docker image
docker build -t deep_docker .


