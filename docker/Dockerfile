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
# Copyright [2020] by snakajim(https://github.com/snakajim)
# ---------------------------------
#
# 1. To build
# $> docker build -t nsatoshi/centos7-verilator --no-cache=true .
# 1-1. or To pull from public repo
# $> docker pull nsatoshi/centos7-verilator:latest
# 2. To run
# $> docker run -it --name eda -u user --privileged --restart=always -d --net host nsatoshi/centos7-verilator:latest sh
#
FROM centos:7
# User info
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
RUN yum -y install cmake git wget.x86_64 tar java motif xterm emacs nano 
RUN yum -y install xz rclone tkcvs graphviz xxd gtkwave 
RUN yum -y install xorg-x11-apps xorg-x11-xauth xorg-x11-fonts-* xorg-x11-utils
RUN yum -y install perl-CPAN
RUN yum -y install python3 python3-devel python3-pip
RUN yum -y install bison flex locales htop clang cpanminus subversion aria2 rsync sudo
RUN pip3 install z3-solver


#  ---------------------------------------------------------------------------------
# SCL to install gcc7/8, and set GCC8 as default compiler
#  ---------------------------------------------------------------------------------
RUN yum -y install centos-release-scl
RUN yum -y install devtoolset-7-gcc devtoolset-7-gcc-c++
RUN yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++
RUN scl enable devtoolset-8 bash

#  ---------------------------------------------------------------------------------
# User apps install as root
#  ---------------------------------------------------------------------------------
RUN mkdir -p ${HOME}/tmp

#
# install the git 2.28.0
#
RUN cd ${HOME}/tmp && \
  aria2c -x10 https://www.kernel.org/pub/software/scm/git/git-2.28.0.tar.gz &&\
  tar -zxf git-2.28.0.tar.gz && cd git-2.28.0 && \
  make configure && ./configure --prefix=/usr && make -j12 && \
  make install
RUN cd ${HOME}/tmp/git-2.28.0 && make clean

#
# install the cmake 3.18.4 
#
RUN cd ${HOME}/tmp && \
  aria2c -x10 https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz &&\
  tar -zxf cmake-3.18.4.tar.gz && cd cmake-3.18.4 && \
  ./configure --prefix=/usr && make -j12 && \
  make install
RUN cd ${HOME}/tmp/cmake-3.18.4 && make clean 

RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# gcc 7.5.0 setting for cmake" >> .bashrc
RUN cd /root && \
  echo "export CMAKE_CXX_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc++">> .bashrc
RUN cd /root && \
  echo "export CMAKE_C_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc">> .bashrc

RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# make sure your CC and CXX to new version" >> .bashrc
RUN cd /root && \
  echo "export CXX=/opt/rh/devtoolset-8/root/usr/bin/g++">> .bashrc
RUN cd /root && \
  echo "export CC=/opt/rh/devtoolset-8/root/usr/bin/gcc">> .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# gcc 7.5.0 setting for cmake" >> .bashrc
RUN cd /etc/skel && \
  echo "export CMAKE_CXX_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc++" >> .bashrc
RUN cd /etc/skel && \
  echo "export CMAKE_C_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc" >> .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# make sure your CC and CXX to new version" >> .bashrc
RUN cd /etc/skel && \
  echo "export CXX=/opt/rh/devtoolset-8/root/usr/bin/g++" >> .bashrc
RUN cd /etc/skel && \
  echo "export CC=/opt/rh/devtoolset-8/root/usr/bin/gcc" >> .bashrc

#
# install verilator 4102
#
RUN source ${HOME}/.bashrc
RUN unset VERILATOR_ROOT 
RUN cd ${HOME}/tmp && mkdir -p verilator && wget --no-check-certificate https://github.com/verilator/verilator/tarball/v4.102 -O verilator-v4.102.tgz
RUN cd ${HOME}/tmp && tar -xvf verilator-v4.102.tgz -C verilator --strip-components 1
RUN cd ${HOME}/tmp/verilator && autoconf && \
  ./configure --prefix=/usr/local/verilator_4102 && make -j12 && \
  make install  
RUN cd ${HOME}/tmp/verilator && make clean
RUN ln -sf /usr/local/verilator_4102/bin/verilator* /usr/local/verilator_4102/share/verilator/bin/

RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# verilator setting" >> .bashrc
RUN cd /root && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4102/share/verilator">> .bashrc
RUN cd /root && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >>  .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# verilator setting" >> .bashrc
RUN cd /etc/skel && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4102/share/verilator">> .bashrc
RUN cd /etc/skel && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >> .bashrc

#
# install llvm11.0.0
#
RUN cd ${HOME}/tmp && aria2c -x10 https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz
RUN cd ${HOME}/tmp && unxz llvm-project-11.0.0.tar.xz && \
  tar xvf llvm-project-11.0.0.tar && \
  cd llvm-project-11.0.0 && mkdir -p build && cd build && \
  cmake -G Ninja -G "Unix Makefiles" \
    -DCMAKE_C_COMPILER="/opt/rh/devtoolset-8/root/usr/bin/gcc" \
    -DCMAKE_CXX_COMPILER="/opt/rh/devtoolset-8/root/usr/bin/g++" \
    -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld" \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64"\
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1100" \
    ../llvm && make -j12 && \
    make install
RUN cd ${HOME}/tmp/llvm-project-11.0.0/build && make clean

RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# LLVM setting" >> .bashrc
RUN cd /root && \
  echo "export LLVM_DIR=/usr/local/llvm_1100">> .bashrc
RUN cd /root && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# LLVM setting" >> .bashrc
RUN cd /etc/skel && \
  echo "export LLVM_DIR=/usr/local/llvm_1100">> .bashrc
RUN cd /etc/skel && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc

#  ---------------------------------------------------------------------------------
# install sbt(Scalar Build Tool)
#  ---------------------------------------------------------------------------------
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum -y install sbt

# ---------------------------------------------------------------------------------
# user add with sudo authority
# ---------------------------------------------------------------------------------
RUN passwd -d root && \
  useradd -m user && passwd -d user && \
  usermod -aG wheel user && chsh -s /bin/bash user
# change setting for user & wheel group
RUN sed -i -E 's/\#auth\s+required\s+pam_wheel\.so\s+use_uid/auth      required      pam_wheel\.so      use_uid/' /etc/pam.d/su
RUN sed -i -E "s/# %wheel\s+ALL=\(ALL\)\s+NOPASSWD:\s+ALL/%wheel        ALL=(ALL)       NOPASSWD: ALL /" /etc/sudoers
RUN exec $SHELL -l

#  ---------------------------------------------------------------------------------
# other tools which are recommeded to install as non-root user
#  ---------------------------------------------------------------------------------
#
# SBT/Chisel3 and Python3 libraries
#
RUN sudo -u user scl enable devtoolset-8 bash && \
  sudo -u user mkdir -p /home/user/work/tmp && sudo -u user mkdir -p /home/user/tmp
RUN sudo -u user sh -c "mkdir -p ${HOME}/work/MyProject && cd ${HOME}/work/MyProject && \
  git clone https://github.com/chipsalliance/firrtl.git  -b v1.4.1 && \
  git clone https://github.com/chipsalliance/treadle.git -b v1.3.1 && \
  pushd firrtl; sbt publishLocal; popd && \
  pushd treadle; sbt publishLocal; popd && \
  git clone https://github.com/chipsalliance/chisel3.git -b v3.4.1 && \
  cd chisel3 && \
  sbt compile && \
  sbt test" 
RUN sudo -u user pip3 install pyyaml numpy pandas openpyxl pydot
#
# Plenv to switch perl version
# https://github.com/tokuhirom/plenv.git
#
RUN sudo -u user cd ${HOME}/tmp && sudo -u user git clone https://github.com/tokuhirom/plenv.git \
    ${HOME}/.plenv
RUN sudo -u user cd ${HOME}/tmp && sudo -u user git clone https://github.com/tokuhirom/Perl-Build.git \
    ${HOME}/.plenv/plugins/perl-build/
RUN sudo -u user echo "# " >> ${HOME}/.bash_profile
RUN sudo -u user echo "# adding plenv path" >> ${HOME}/.bash_profile
RUN sudo -u user echo "export PATH=~/.plenv/bin:\$PATH" >>  ${HOME}/.bash_profile
RUN sudo -u user echo 'eval "$(plenv init -)"' >> ${HOME}/.bash_profile    
#
# MS VS Code for linux
#
RUN sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
RUN sudo yum check-update && sudo yum -y install code

#  ---------------------------------------------------------------------------------
# reset container
#  ---------------------------------------------------------------------------------
RUN rm -rf /root/tmp/*
CMD /sbin/init
CMD echo "now build completed...nsatoshi/centos7-verilator"
