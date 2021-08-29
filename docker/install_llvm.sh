#!/bin/bash
#
# Intall LLVM
# https://llvm.org/docs/GettingStarted.html#checkout
#
# used for CENTOS only
#
LLVM_VERSION="12.0.1"

mkdir -p ${HOME}/tmp && rm -rf ${HOME}/tmp/llvm-project* 
cd ${HOME}/tmp && aria2c -x10 https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-project-${LLVM_VERSION}.src.tar.xz
cd ${HOME}/tmp && unxz llvm-project-${LLVM_VERSION}.src.tar.xz && \
  tar xvf llvm-project-${LLVM_VERSION}.src.tar && \
  cd llvm-project-${LLVM_VERSION}.src && mkdir -p build && cd build && \
  cmake -G Ninja -G "Unix Makefiles" \
    -DCMAKE_C_COMPILER="/opt/rh/devtoolset-8/root/usr/bin/gcc" \
    -DCMAKE_CXX_COMPILER="/opt/rh/devtoolset-8/root/usr/bin/g++" \
    -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld" \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64"\
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_1201" \
    ../llvm && make -j`nproc` && \
    make install
cd ${HOME}/tmp/llvm-project-${LLVM_VERSION}.src/build && make clean

cd /root && \
  echo "# " >> .bashrc
cd /root && \
  echo "# LLVM setting" >> .bashrc
cd /root && \
  echo "export LLVM_DIR=/usr/local/llvm_1201">> .bashrc
cd /root && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc

cd /etc/skel && \
  echo "# " >> .bashrc
cd /etc/skel && \
  echo "# LLVM setting" >> .bashrc
cd /etc/skel && \
  echo "export LLVM_DIR=/usr/local/llvm_1201">> .bashrc
cd /etc/skel && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc
