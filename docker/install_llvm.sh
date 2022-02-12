#!/bin/bash
#
# Intall LLVM
# https://llvm.org/docs/GettingStarted.html#checkout
#
# used for CENTOS7 only
#
LLVM_VERSION="13.0.1"

mkdir -p ${HOME}/tmp && rm -rf ${HOME}/tmp/llvm-project* 
cd ${HOME}/tmp && aria2c -x10 https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/llvm-project-${LLVM_VERSION}.src.tar.xz
cd ${HOME}/tmp && unxz llvm-project-${LLVM_VERSION}.src.tar.xz && \
  tar xvf llvm-project-${LLVM_VERSION}.src.tar && \
  cd llvm-project-${LLVM_VERSION}.src && mkdir -p build && cd build && \
  cmake -G Ninja -G "Unix Makefiles" \
    -DCMAKE_C_COMPILER=`which gcc` \
    -DCMAKE_CXX_COMPILER=`which g++` \
    -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld" \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DLLVM_TARGETS_TO_BUILD="ARM;X86;AArch64"\
    -DCMAKE_INSTALL_PREFIX="/usr/local/llvm_${LLVM_VERSION}" \
    ../llvm && make -j`nproc` && \
    sudo make install
cd ${HOME}/tmp/llvm-project-${LLVM_VERSION}.src/build && make clean

cd ${HOME} && \
  echo "# " >> .bashrc
cd ${HOME} && \
  echo "# LLVM setting" >> .bashrc
cd ${HOME} && \
  echo "export LLVM_DIR=/usr/local/llvm_${LLVM_VERSION}">> .bashrc
cd ${HOME} && \
  echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc

cd /etc/skel && \
  sudo echo "# " >> .bashrc
cd /etc/skel && \
  sudo echo "# LLVM setting" >> .bashrc
cd /etc/skel && \
  sudo echo "export LLVM_DIR=/usr/local/llvm_${LLVM_VERSION}">> .bashrc
cd /etc/skel && \
  sudo echo "export PATH=\$LLVM_DIR/bin:\$PATH" >> .bashrc

source ~/.bashrc && sudo ldconfig -v