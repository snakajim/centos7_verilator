#!/bin/bash
# install_verilator.sh
#

#
# Check LLVM ${LLVM_VERSION} if not available
#
source ~/.bashrc
which clang
ret=$?
if [ $ret == '0' ]; then
  CLANG_VERSION=$(clang --version | awk 'NR<2 { print $3 }' | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
else
  CLANG_VERSION="0"
fi

if [ "$CLANG_VERSION" -gt 150000 ]; then
  export CC=`which clang`
  export CXX=`which clang++`
  export CMAKE_CXX_COMPILER=`which clang++`
  export CMAKE_C_COMPILER=`which clang`
  echo "Set tool chain LLVM"
else
  export CC=/opt/rh/devtoolset-8/root/usr/bin/gcc
  export CXX=/opt/rh/devtoolset-8/root/usr/bin/g++
  export CMAKE_CXX_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc++
  export CMAKE_C_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc
  echo "Set tool chain gcc"
fi

#
# install verilator 4_${VERILATOR_REV}
#
unset VERILATOR_ROOT 
VERILATOR_REV="214"
mkdir -p ${HOME}/tmp && cd ${HOME}/tmp && rm -rf ${HOME}/tmp/verilator 
mkdir -p verilator && wget --no-check-certificate https://github.com/verilator/verilator/tarball/v4.${VERILATOR_REV} -O verilator-v4.${VERILATOR_REV}.tgz
cd ${HOME}/tmp && tar -xvf verilator-v4.${VERILATOR_REV}.tgz -C verilator --strip-components 1
start_time=`date +%s`
cd ${HOME}/tmp/verilator && autoconf && \
  ./configure --prefix=/usr/local/verilator_4_${VERILATOR_REV} \
  CC=$CC \
  CXX=$CXX && \
  make -j`nproc` && \
  sudo make install
end_time=`date +%s`
run_time=$((end_time - start_time))
cd ${HOME}/tmp/verilator && make clean
sudo ln -sf /usr/local/verilator_4_${VERILATOR_REV}/bin/verilator* /usr/local/verilator_4_${VERILATOR_REV}/share/verilator/bin/

cd ${HOME} && \
  echo "# " >> .bashrc
cd ${HOME} && \
  echo "# verilator setting" >> .bashrc
cd ${HOME} && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4_${VERILATOR_REV}/share/verilator">> .bashrc
cd ${HOME} && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >> .bashrc

cd /etc/skel && \
  sudo echo "# " >> .bashrc
cd /etc/skel && \
  sudo echo "# verilator setting" >> .bashrc
cd /etc/skel && \
  sudo echo "export VERILATOR_ROOT=/usr/local/verilator_4_${VERILATOR_REV}/share/verilator">> .bashrc
cd /etc/skel && \
  sudo echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >> .bashrc

echo "cat /proc/cpuinfo" > ${HOME}/tmp/run.log
cat /proc/cpuinfo  >> ${HOME}/tmp/run.log
echo "nproc" >> ${HOME}/tmp/run.log
nproc >> ${HOME}/tmp/run.log
echo "tool chain version" >> ${HOME}/tmp/run.log
$CC --version >> ${HOME}/tmp/run.log
echo "install_verilator.sh costs $run_time [sec]." >> ${HOME}/tmp/run.log
echo ""