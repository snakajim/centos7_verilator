#!/bin/bash
#
# This script is assumed to at root.
# For non root user, use sudo to swith root authority.
# $> sudo sh -c ./install_tools.sh
#

#
# install the git 2.33.0
#
mkdir -p ${HOME}/tmp && rm -rf ${HOME}/tmp/git-2.33.0
cd ${HOME}/tmp && \
  aria2c -x10 https://www.kernel.org/pub/software/scm/git/git-2.33.0.tar.gz &&\
  tar -zxf git-2.33.0.tar.gz && cd git-2.33.0 && \
  make configure && \
  ./configure --prefix=/usr \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && make install
cd ${HOME}/tmp/git-2.33.0 && make clean

#
# install the cmake 3.18.4 
#
cd ${HOME}/tmp && \
  aria2c -x10 https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz &&\
  tar -zxf cmake-3.18.4.tar.gz && cd cmake-3.18.4 && \
  ./configure --prefix=/usr \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && make install
cd ${HOME}/tmp/cmake-3.18.4 && make clean 