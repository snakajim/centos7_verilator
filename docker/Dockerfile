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
# $> docker run -it -p 20022:22 -e DISPLAY=$DISPLAY --name eda -u user0 --privileged --restart=always -d --net host nsatoshi/centos7-verilator:latest sh
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
# switching default gcc and g++ to version-8.
#

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
# install the git 2.28.0
#
RUN cd ${HOME}/tmp && \
  aria2c -x10 https://www.kernel.org/pub/software/scm/git/git-2.28.0.tar.gz &&\
  tar -zxf git-2.28.0.tar.gz && cd git-2.28.0 && \
  make configure && \
  ./configure --prefix=/usr \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && make install
RUN cd ${HOME}/tmp/git-2.28.0 && make clean

#
# install the cmake 3.18.4 
#
RUN cd ${HOME}/tmp && \
  aria2c -x10 https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz &&\
  tar -zxf cmake-3.18.4.tar.gz && cd cmake-3.18.4 && \
  ./configure --prefix=/usr \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && make install
RUN cd ${HOME}/tmp/cmake-3.18.4 && make clean 

#
# install verilator 4_${VERILATOR_REV}
#
RUN source ${HOME}/.bashrc
RUN unset VERILATOR_ROOT 
ENV VERILATOR_REV=210
RUN cd ${HOME}/tmp && mkdir -p verilator && wget --no-check-certificate https://github.com/verilator/verilator/tarball/v4.${VERILATOR_REV} -O verilator-v4.${VERILATOR_REV}.tgz
RUN cd ${HOME}/tmp && tar -xvf verilator-v4.${VERILATOR_REV}.tgz -C verilator --strip-components 1
RUN cd ${HOME}/tmp/verilator && autoconf && \
  ./configure --prefix=/usr/local/verilator_4_${VERILATOR_REV} \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && \
  make install  
RUN cd ${HOME}/tmp/verilator && make clean
RUN ln -sf /usr/local/verilator_4_${VERILATOR_REV}/bin/verilator* /usr/local/verilator_4_${VERILATOR_REV}/share/verilator/bin/

RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# verilator setting" >> .bashrc
RUN cd /root && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4_${VERILATOR_REV}/share/verilator">> .bashrc
RUN cd /root && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >>  .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# verilator setting" >> .bashrc
RUN cd /etc/skel && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4_${VERILATOR_REV}/share/verilator">> .bashrc
RUN cd /etc/skel && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >> .bashrc

#
# install llvm12.0.1
#
RUN cd ${HOME}/tmp && aria2c -x10 https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-project-12.0.1.src.tar.xz
RUN cd ${HOME}/tmp && unxz llvm-project-12.0.1.src.tar.xz && \
  tar xvf llvm-project-12.0.1.src.tar && \
  cd llvm-project-12.0.1.src && mkdir -p build && cd build && \
  cmake -G Ninja -G "Unix Makefiles" \
    -DCMAKE_C_COMPILER="/opt/rh/devtoolset-8/root/usr/bin/gcc" \
    -DCMAKE_CXX_COMPILER="/opt/rh/devtoolset-8/root/usr/bin/g++" \
    -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld" \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64"\
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1201" \
    ../llvm && make -j`nproc` && \
    make install
RUN cd ${HOME}/tmp/llvm-project-12.0.1.src/build && make clean

RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# LLVM setting" >> .bashrc
RUN cd /root && \
  echo "export LLVM_DIR=/usr/local/llvm_1201">> .bashrc
RUN cd /root && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# LLVM setting" >> .bashrc
RUN cd /etc/skel && \
  echo "export LLVM_DIR=/usr/local/llvm_1201">> .bashrc
RUN cd /etc/skel && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc
# force lld to use instead of ld.
RUN rm -f /usr/bin/ld && ln -s  /usr/local/llvm_1201/bin/lld /usr/bin/ld

#
# Install aarch64-linux gnu Version 10.2-2020.11 
#
RUN cd ${HOME}/tmp && \
  aria2c -x10 https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
  unxz gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
  tar xvf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar -C /usr/local
RUN cd /root && \
  echo "# " >> .bashrc
RUN cd /root && \
  echo "# aarch64-linux-gnu- setting" >> .bashrc
RUN cd /root && \
  echo "export AARCH64_LINUX_GNU_DIR=/usr/local/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu">> .bashrc
RUN cd /root && \
  echo "export PATH=\$AARCH64_LINUX_GNU_DIR/bin:\$PATH" >> .bashrc

RUN cd /etc/skel && \
  echo "# " >> .bashrc
RUN cd /etc/skel && \
  echo "# aarch64-linux-gnu- setting" >> .bashrc
RUN cd /etc/skel && \
  echo "export AARCH64_LINUX_GNU_DIR=/usr/local/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu">> .bashrc
RUN cd /etc/skel && \
  echo "export PATH=\$AARCH64_LINUX_GNU_DIR/bin:\$PATH" >> .bashrc
# In clang command option, please add
# --target=aarch64-linux-gnu -I/usr/include/c++/4.8.2/x86_64-redhat-linux -I/usr/include/c++/4.8.2/x86_64-redhat-linux/bits

#  ---------------------------------------------------------------------------------
# install sbt(Scalar Build Tool)
#  ---------------------------------------------------------------------------------
RUN rm -f /etc/yum.repos.d/bintray-rpm.repo
RUN mkdir -p ${HOME}/work && cd ${HOME}/work && curl -L https://www.scala-sbt.org/sbt-rpm.repo > sbt-rpm.repo
RUN mv ${HOME}/work/sbt-rpm.repo /etc/yum.repos.d/
RUN yum -y install sbt-1.5.5-0.noarch

#
# install MS VS Code for linux
#
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
RUN sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
RUN yum check-update && sudo yum -y install code
RUN yum clean all

#
# set sshd_config, exporse port 22 and start sshd daemon
#
RUN sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config
RUN sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

# ---------------------------------------------------------------------------------
# user0 add with sudo authority
# ---------------------------------------------------------------------------------
RUN passwd -d root && \
  useradd -m user0 && passwd -d user0 && \
  usermod -aG wheel user0 && chsh -s /bin/bash user0
# change setting for user0 & wheel group
RUN sed -i -E 's/\#auth\s+required\s+pam_wheel\.so\s+use_uid/auth      required      pam_wheel\.so      use_uid/' /etc/pam.d/su
RUN sed -i -E "s/# %wheel\s+ALL=\(ALL\)\s+NOPASSWD:\s+ALL/%wheel        ALL=(ALL)       NOPASSWD: ALL /" /etc/sudoers
RUN exec $SHELL -l

#  ---------------------------------------------------------------------------------
# other tools which are recommeded to install as non-root user
#  ---------------------------------------------------------------------------------
#
# SBT/Chisel3
#
# set gcc to 8
RUN sudo -u user0 sh -c "scl enable devtoolset-8 bash"
RUN sudo -u user0 sh -c "mkdir -p \${HOME}/work/MyProject"
RUN sudo -u user0 sh -c "mkdir -p \${HOME}/tmp"
# install firrtl v1.4.1
RUN sudo -u user0 sh -c "git clone --depth=1 https://github.com/freechipsproject/firrtl.git -b v1.4.3 \${HOME}/.firrtl"
RUN sudo -u user0 sh -c "cd \${HOME}/.firrtl && sbt compile"
RUN sudo -u user0 sh -c "cd \${HOME}/.firrtl && sbt assembly"
RUN sudo -u user0 sh -c "cd \${HOME} && echo '# adding firrtl path' >> .bashrc"
RUN sudo -u user0 sh -c "cd \${HOME} && echo 'export FIRRTL_PATH=\${HOME}/.firrtl/utils/bin'  >> .bashrc"
RUN sudo -u user0 sh -c "cd \${HOME} && echo 'export PATH=\$FIRRTL_PATH:\$PATH' >> .bashrc"
# install sv2chisel
RUN sudo -u user0 sh -c "git clone --depth=1 https://github.com/ovh/sv2chisel.git \${HOME}/.sv2chisel"
RUN sudo -u user0 sh -c "cd \${HOME}/.sv2chisel && sbt compile"
RUN sudo -u user0 sh -c "cd \${HOME}/.sv2chisel && sbt test"
RUN sudo -u user0 sh -c "cd \${HOME}/.sv2chisel && sbt publishLocal"

#
# Downlaod ACL v21.05, dependencies and patching ComputeLibrary/SConstruct for cross compile.
#
RUN sudo -u user0 sh -c "mkdir -p \${HOME}/acl && cd \${HOME}/acl && git clone --depth=1 https://github.com/ARM-software/ComputeLibrary.git -b v21.05"
RUN sudo -u user0 sh -c "cd \${HOME}/acl/ComputeLibrary && perl -pe 's/armv8\.2-a\+fp16'/armv8\.2-a\+fp16\+dotprod'/g' -i ./SConstruct"
RUN sudo -u user0 sh -c "cd \${HOME}/acl/ComputeLibrary && perl -pe 's/aarch64-linux-gnu-/aarch64-none-linux-gnu-/g' -i ./SConstruct"

#
# Plenv to switch perl version
# https://github.com/tokuhirom/plenv.git
#
RUN sudo -u user0 sh -c "git clone --depth=1 -b 2.3.1 https://github.com/tokuhirom/plenv.git \${HOME}/.plenv"
RUN sudo -u user0 sh -c "git clone --depth=1 -b 1.32 https://github.com/tokuhirom/Perl-Build.git \${HOME}/.plenv/plugins/perl-build/"
RUN sudo -u user0 sh -c "cd \${HOME} && echo '# adding plenv path' >> .bash_profile"
RUN sudo -u user0 sh -c "cd \${HOME} && echo 'export PATH=\${HOME}/.plenv/bin:\$PATH' >> .bash_profile"
RUN sudo -u user0 sh -c "cd \${HOME} && echo 'eval "$(\${HOME}/.plenv/bin/plenv init -)"' >> .bash_profile"

#  ---------------------------------------------------------------------------------
# reset container
#  ---------------------------------------------------------------------------------
RUN rm -rf /root/tmp/*
RUN cd /home/user0
CMD /sbin/init
CMD echo "now build completed... > docker push nsatoshi/centos7-verilator"
