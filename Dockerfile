FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

MAINTAINER Aleksei Tiulpin, University of Oulu, Version 3.0


# Parameters to re-create the user teh same way as in the system
ARG HOST_USER
ARG UID
ARG GID

# Setting up the system
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y libgtk2.0-dev
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
	     unzip \
	     zip \
	     locales \
	     emacs \
	     libgl1-mesa-glx \
	     openssh-server \
	     screen \	 	  
	     libturbojpeg \
	     rsync \
         wget

RUN locale-gen --purge en_US.UTF-8
RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale
RUN dpkg-reconfigure --frontend=noninteractive locales

# SSH access
RUN mkdir /var/run/sshd
RUN echo 'root:67923hjksdii$66%4!0+92' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir -p /root/.ssh/

# Creating the user
RUN groupadd -g $GID $HOST_USER
RUN useradd --create-home --home-dir /home/${HOST_USER}/ -u $UID -g $GID -s /bin/bash $HOST_USER
RUN chown -R $UID:$GID /home/${HOST_USER}/

# Uner host's username privided we will setup anaconda and stuff
USER $HOST_USER

RUN mkdir -p /home/${HOST_USER}/.ssh/
RUN echo "export PATH=/home/${HOST_USER}/conda/bin:${PATH}" >> /home/${HOST_USER}/.bashrc

# Getting conda
RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p /home/${HOST_USER}/conda && rm ~/miniconda.sh
ENV PATH=/home/${HOST_USER}/conda/bin:${PATH}
RUN conda update -n base conda

RUN conda install -y python=3.6
RUN conda install -y numpy pyyaml scipy ipython openblas mkl matplotlib cython

RUN pip install --ignore-installed pip -U -v
RUN pip install --ignore-installed jpeg4py
RUN pip install --ignore-installed tensorflow tensorboardx scikit-learn pandas jupyterlab keras
RUN pip install --ignore-installed termcolor tqdm
RUN pip install --ignore-installed opencv-python
RUN pip install --ignore-installed http://download.pytorch.org/whl/cu91/torch-0.4.0-cp36-cp36m-linux_x86_64.whl
RUN pip install --ignore-installed torchvision
RUN pip install --ignore-installed pydicom
RUN pip install --ignore-installed pretrainedmodels

USER root
RUN echo "${HOST_USER}" >> /etc/sudoers

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


