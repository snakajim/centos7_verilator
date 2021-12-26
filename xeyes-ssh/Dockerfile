# Dockerfile.focal
#
# SYNOPSIS
# ssh connectable Focal docker container.
#
# To build:
# $> docker build -t sshd_focal -f Dockerfile .
# To run: 
# $> docker run -d -P --name test_sshd sshd_focal
# $> docker port test_sshd 22/tcp
# $> $ ssh root@localhost -p <port shown above>
# or
# $> $ ssh user0@localhost -p <port shown above>
# To fix port:
# Use "-p <your binded port>:22" option instead of "-P"
#
# See details in 
# https://docs.docker.jp/engine/examples/running_ssh_service.html
#
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get -y install x11-apps

#
# Install OpenSSH and enable ssh connection to Focal container.
#
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
#
# add user0 as sudo group
#
RUN apt-get -y install nano sudo
RUN useradd -m -b /home -s /bin/bash user0
RUN echo 'user0:user0' | chpasswd
RUN sed -i 's/^%sudo\s*ALL=(ALL:ALL) ALL/%sudo ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN usermod -aG sudo user0
#
# exit
#
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
