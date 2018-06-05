# This allows a secure two-way communication between our Docker and remote server
# Copying host pubkey to image
cat /home/$USER/.ssh/id_rsa.pub > authorized_keys
echo "\n" >> authorized_keys

# Building the Docker image
docker build -t deep_docker .


