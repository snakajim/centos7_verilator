#!/bin/bash
# install_verilator.sh
#
#
# install verilator 4_${VERILATOR_REV}
#
unset VERILATOR_ROOT 
VERILATOR_REV="214"
cd ${HOME}/tmp && rm -rf ${HOME}/tmp/verilator 
mkdir -p verilator && wget --no-check-certificate https://github.com/verilator/verilator/tarball/v4.${VERILATOR_REV} -O verilator-v4.${VERILATOR_REV}.tgz
cd ${HOME}/tmp && tar -xvf verilator-v4.${VERILATOR_REV}.tgz -C verilator --strip-components 1
cd ${HOME}/tmp/verilator && autoconf && \
  ./configure --prefix=/usr/local/verilator_4_${VERILATOR_REV} \
  CC=/opt/rh/devtoolset-8/root/usr/bin/gcc \
  CXX=/opt/rh/devtoolset-8/root/usr/bin/g++ && \
  make -j`nproc` && \
  sudo make install  
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
