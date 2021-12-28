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
# $> docker build -t nsatoshi/centos7-verilator -f Dockerfile .
# 1-1. or To pull from public repo
# $> docker pull nsatoshi/centos7-verilator:latest
# 2. To run
# $> docker run -d -p 20022:22 --name eda --hostname cs7 --restart=always nsatoshi/centos7-verilator:latest
# 3. To access from host via ssh
# $> ssh -p 20022 user0@localhost (as "user0" passwd)
# or
# $> ssh -p 20022 root@localhost (as "root" passwd)
#
FROM centos:7
LABEL maintainer="nsatoshi"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
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
RUN yum -y install cmake git wget.x86_64 tar motif xterm emacs nano 
RUN yum -y install xz rclone tkcvs graphviz xxd gtkwave time
RUN yum -y install xorg-x11-apps xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils
RUN yum -y install perl-CPAN
RUN yum -y install python3 python3-devel python3-pip scons
RUN yum -y install openssh-server openssh-clients
RUN yum -y install bison flex locales htop clang cpanminus subversion aria2 rsync sudo
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
RUN chmod 755 /scripts/change_gcc_ver.sh
RUN sed -i 's/\r//' /scripts/change_gcc_ver.sh
RUN /scripts/change_gcc_ver.sh

#  ---------------------------------------------------------------------------------
# Install tools to newer as root
#  ---------------------------------------------------------------------------------
ADD ./install_tools.sh /scripts/install_tools.sh
RUN chmod 755 /scripts/install_tools.sh
RUN sed -i 's/\r//' /scripts/install_tools.sh
RUN /scripts/install_tools.sh

#  ---------------------------------------------------------------------------------
# Install verilator as root
#  ---------------------------------------------------------------------------------
ADD ./install_verilator.sh /scripts/install_verilator.sh
RUN chmod 755 /scripts/install_verilator.sh
RUN sed -i 's/\r//' /scripts/install_verilator.sh
RUN /scripts/install_verilator.sh

#  ---------------------------------------------------------------------------------
# Install llvm as root
#  ---------------------------------------------------------------------------------
ADD ./install_llvm.sh /scripts/install_llvm.sh
RUN chmod 755 /scripts/install_llvm.sh
RUN sed -i 's/\r//' /scripts/install_llvm.sh
RUN /scripts/install_llvm.sh

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

#  ---------------------------------------------------------------------------------
# install user apps by start.sh
#  ---------------------------------------------------------------------------------
ADD ./start.sh /scripts/start.sh
RUN chmod 755 /scripts/start.sh
RUN sed -i 's/\r//' /scripts/start.sh
RUN /scripts/start.sh

#  ---------------------------------------------------------------------------------
# reset container
#  ---------------------------------------------------------------------------------
RUN rm -rf /root/tmp/*
RUN cd /home/user0
CMD echo "now build completed... > docker push nsatoshi/centos7-verilator"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
