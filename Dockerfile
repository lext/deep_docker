FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

MAINTAINER Aleksei Tiulpin, University of Oulu, Version 2.0

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


# Getting conda
RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN chmod +x ~/miniconda.sh && ~/miniconda.sh -b -p /opt/conda && rm ~/miniconda.sh
ENV PATH=/opt/conda/bin:${PATH}
RUN conda update -n base conda

# DL packages
RUN pip install jpeg4py
RUN conda install -y python=3.6.5
RUN conda install -y -c soumith magma-cuda91
RUN conda install -y numpy pyyaml scipy ipython mkl matplotlib
RUN pip install tensorflow tensorboardx scikit-learn pandas jupyterlab keras
RUN pip install termcolor tqdm
RUN pip install opencv-python
RUN pip install http://download.pytorch.org/whl/cu91/torch-0.4.0-cp36-cp36m-linux_x86_64.whl
RUN pip install torchvision
RUN pip install pydicom

# SSH access
RUN mkdir /var/run/sshd
RUN echo 'root:67923hjksdii$66%4!0+92' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir -p /root/.ssh/
RUN echo "export PATH=$PATH:/opt/conda/bin" >> /root/.bashrc

# Setting the scripts to setup the environment
COPY run_screens_docker.sh /root/
COPY authorized_keys /root/.ssh/authorized_keys
COPY docker_identity /root/.ssh/id_rsa
COPY docker_identity.pub /root/.ssh/id_rsa.pub
COPY gitconfig /root/.gitconfig

RUN chown -R root:root /root
RUN chmod -R 600 /root 

ARG HOST_USER
RUN groupadd $HOST_USER
RUN usermod -a -G $HOST_USER root


EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]


