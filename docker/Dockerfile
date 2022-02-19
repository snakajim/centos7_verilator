#
#Licensed to the Apache Software Foundation (ASF) under one
#or more contributor license agreements.  See the NOTICE file
#distributed with this work for additional information
#regarding copyright ownership.  The ASF licenses this file
#to you under the Apache License, Version 2.0 (the
#"License"); you may not use this file except in compliance
#with the License.  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing,
#software distributed under the License is distributed on an
#"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#KIND, either express or implied.  See the License for the
#specific language governing permissions and limitations
#under the License.
#
# ---------------------------------
# Dockerfile for centos7_verilator
# Copyright [2020-2021] by snakajim(https://github.com/snakajim)
# ---------------------------------
#
# 1. To build
# $> docker build -t nsatoshi/centos7-verilator --build-arg UBLUSER="user0" -f Dockerfile . --no-cache
# 1-1. or To pull from public repo
# $> docker pull nsatoshi/centos7-verilator
# 2. To run
# $> docker run -d -P --name eda --hostname cs7 --restart=always nsatoshi/centos7-verilator
# 3. To access from host via ssh
# $> ssh -p xxxx ${UBLUSER}@localhost (as "${UBLUSER}" passwd)
# or
# $> ssh -p xxxx root@localhost (as "root" passwd)
#
FROM centos:7
LABEL maintainer="nsatoshi"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ARG UBLUSER="user0"

#
# 2020/Nov/08, patch for systemd D-Bus known bug in CENTOS7.
# See https://hub.docker.com/_/centos?tab=description, Systemd integration
#
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

#
# install standard apps
#
RUN yum -y install epel-release
RUN yum -y install elrepo-release
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y update --skip-broken
RUN yum -y upgrade
RUN yum -y groupinstall "Development Tools"
RUN yum -y groupinstall "Additional Development"
# RUN : docker build
RUN echo "now building...."
# set JPN mirror site instead of default server in US.
RUN echo "include_only=.jp" >> /etc/yum/pluginconf.d/fastestmirror.conf
RUN yum clean all
RUN yum -y install kernel-devel kernel-headers
RUN yum -y install cmake git wget.x86_64 tar motif xterm emacs nano curl
RUN yum -y install xz rclone tkcvs graphviz xxd gtkwave time
RUN yum -y install xorg-x11-apps xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils
RUN yum -y install perl-CPAN
RUN yum -y install python3 python3-devel python3-pip scons
RUN yum -y install openssh-server openssh-clients
RUN yum -y install bison flex locales htop clang cpanminus subversion aria2 rsync nano sudo
RUN pip3 install z3-solver pyyaml numpy pandas openpyxl pydot

#  ---------------------------------------------------------------------------------
# User apps install as root
#  ---------------------------------------------------------------------------------
RUN mkdir -p ${HOME}/tmp

#  ---------------------------------------------------------------------------------
# Change gcc vertion to newer as root
#  ---------------------------------------------------------------------------------
RUN mkdir -p /scripts
ADD ./change_gcc_ver.sh /scripts/change_gcc_ver.sh
RUN chmod +x /scripts/change_gcc_ver.sh
RUN sed -i 's/\r//' /scripts/change_gcc_ver.sh
#RUN /scripts/change_gcc_ver.sh
RUN curl https://raw.githubusercontent.com/snakajim/centos7_install_tools/main/install_gcc_cmake_git_as_default.sh \
  > /scripts/install_gcc_cmake_git_as_default.sh
RUN chmod +x /scripts/install_gcc_cmake_git_as_default.sh
RUN sed -i 's/\r//' /scripts/install_gcc_cmake_git_as_default.sh
RUN /scripts/install_gcc_cmake_git_as_default.sh

#  ---------------------------------------------------------------------------------
# Install llvm as root
#  ---------------------------------------------------------------------------------
RUN curl https://raw.githubusercontent.com/snakajim/centos7_install_tools/main/install_llvm.sh \
  > /scripts/install_llvm.sh
RUN chmod +x /scripts/install_llvm.sh
RUN sed -i 's/\r//' /scripts/install_llvm.sh
RUN /scripts/install_llvm.sh

#  ---------------------------------------------------------------------------------
# Install verilator as root
#  ---------------------------------------------------------------------------------
#ADD ./install_verilator.sh /scripts/install_verilator.sh
RUN curl https://raw.githubusercontent.com/snakajim/centos7_install_tools/main/install_verilator.sh \
 > /scripts/install_verilator.sh
RUN chmod +x /scripts/install_verilator.sh
RUN sed -i 's/\r//' /scripts/install_verilator.sh
RUN /scripts/install_verilator.sh

#  ---------------------------------------------------------------------------------
# install sbt(Scalar Build Tool)
#  ---------------------------------------------------------------------------------
RUN rm -f /etc/yum.repos.d/bintray-rpm.repo
RUN mkdir -p ${HOME}/work && cd ${HOME}/work && curl -L https://www.scala-sbt.org/sbt-rpm.repo > sbt-rpm.repo
RUN mv ${HOME}/work/sbt-rpm.repo /etc/yum.repos.d/
RUN yum -y install sbt-1.5.5-0.noarch

#  ---------------------------------------------------------------------------------
# Install openssl and set sshd_config, exporse port 22
#  ---------------------------------------------------------------------------------
RUN yum -y install openssh-server openssh-clients xeyes
RUN sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config
RUN sed -i 's/^#X11UseLocalhost yes/X11UseLocalhost yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#AddressFamily any/AddressFamily inet/' /etc/ssh/sshd_config
RUN sed -i 's/^#AllowTcpForwarding yes/AllowTcpForwarding yes/' /etc/ssh/sshd_config
RUN systemctl enable sshd.service
RUN ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
RUN echo 'root:root' | chpasswd

#  ---------------------------------------------------------------------------------
# add ${UBLUSER} as wheel group
#  ---------------------------------------------------------------------------------
RUN useradd -m -b /home -s /bin/bash ${UBLUSER}
RUN echo ${UBLUSER}:${UBLUSER} | chpasswd
RUN sed -i 's/^# %wheel\s*ALL=(ALL)\s*NOPASSWD: ALL/ %wheel        ALL=(ALL)       NOPASSWD: ALL/' /etc/sudoers
RUN usermod -aG wheel ${UBLUSER}
RUN sudo -u ${UBLUSER} sh -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_test' 
RUN sudo -u ${UBLUSER} sh -c 'cat ~/.ssh/id_rsa_test.pub >> ~/.ssh/authorized_keys'
RUN sudo -u ${UBLUSER} sh -c 'chmod 600 ~/.ssh/*'
#  ---------------------------------------------------------------------------------
# install user apps by install_userapps.sh
#  ---------------------------------------------------------------------------------
ADD ./install_userapps.sh /scripts/install_userapps.sh
RUN chmod 755 /scripts/install_userapps.sh
RUN sed -i 's/\r//' /scripts/install_userapps.sh
#RUN /scripts/install_userapps.sh

#  ---------------------------------------------------------------------------------
# COPY supervisord.conf
# In CentOS7, dislike Ubuntu, store config in /etc/supervisord.conf.
#  ---------------------------------------------------------------------------------
RUN yum -y install openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisord.conf
RUN sed -i 's/\r//' /etc/supervisord.conf
RUN chmod +x /etc/supervisord.conf

#  ---------------------------------------------------------------------------------
# reset container
#  ---------------------------------------------------------------------------------
RUN rm -rf /root/tmp/*
RUN cd /home/${UBLUSER}
RUN yum autoremove -y && yum clean all -y
CMD echo "now build completed... > docker push nsatoshi/centos7-verilator"
EXPOSE 22
CMD ["/usr/bin/supervisord"]
