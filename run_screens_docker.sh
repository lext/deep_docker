#! /bin/sh 

# Lanunching jupyter lab
CMD="jupyter lab --ip=0.0.0.0 --allow-root --NotebookApp.password='sha1:9b0f8b295713:38b3706f9716be3febcf1bd31ae03b74718fa5d7'"
SCR_NAME="jpnb"
screen -dmS $SCR_NAME
screen -S $SCR_NAME -X stuff "export PATH=/opt/conda/bin/:$PATH\n"
screen -S $SCR_NAME -X stuff "cd /\n"
screen -S $SCR_NAME -X stuff "$CMD\n"

# Launching tensorboard
CMD="tensorboard --logdir /data/tb_logs_docker"
SCR_NAME="tboard"
screen -dmS $SCR_NAME 
screen -S $SCR_NAME -X stuff "export PATH=/opt/conda/bin/:$PATH\n"
screen -S $SCR_NAME -X stuff "$CMD\n"
