#!/bin/bash
# install_verilator.sh
#
#
# install verilator 4_${VERILATOR_REV}
#
source ${HOME}/.bashrc
unset VERILATOR_ROOT 
VERILATOR_REV="210"
cd ${HOME}/tmp && rm -rf ${HOME}/tmp/verilator 
mkdir -p verilator && wget --no-check-certificate https://github.com/verilator/verilator/tarball/v4.${VERILATOR_REV} -O verilator-v4.${VERILATOR_REV}.tgz
cd ${HOME}/tmp && tar -xvf verilator-v4.${VERILATOR_REV}.tgz -C verilator --strip-components 1
cd ${HOME}/tmp/verilator && autoconf && \
  ./configure --prefix=/usr/local/verilator_4_${VERILATOR_REV} \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && \
  make install  
cd ${HOME}/tmp/verilator && make clean
ln -sf /usr/local/verilator_4_${VERILATOR_REV}/bin/verilator* /usr/local/verilator_4_${VERILATOR_REV}/share/verilator/bin/

cd /root && \
  echo "# " >> .bashrc
cd /root && \
  echo "# verilator setting" >> .bashrc
cd /root && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4_${VERILATOR_REV}/share/verilator">> .bashrc
cd /root && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >>  .bashrc

cd /etc/skel && \
  echo "# " >> .bashrc
cd /etc/skel && \
  echo "# verilator setting" >> .bashrc
cd /etc/skel && \
  echo "export VERILATOR_ROOT=/usr/local/verilator_4_${VERILATOR_REV}/share/verilator">> .bashrc
cd /etc/skel && \
  echo "export PATH=\$VERILATOR_ROOT/bin:\$PATH" >> .bashrc