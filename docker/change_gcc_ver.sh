#  ---------------------------------------------------------------------------------
# SCL to install gcc7/8, and set GCC8 as default compiler
#  ---------------------------------------------------------------------------------
yum -y install centos-release-scl
yum -y install devtoolset-7-gcc devtoolset-7-gcc-c++
yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++
scl enable devtoolset-8 bash
#
# switching default gcc and g++ to version-8.
#
cd /root && \
  echo "# " >> .bashrc
cd /root && \
  echo "# gcc 7.5.0 setting for cmake" >> .bashrc
cd /root && \
  echo "export CMAKE_CXX_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc++">> .bashrc
cd /root && \
  echo "export CMAKE_C_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc">> .bashrc

cd /root && \
  echo "# " >> .bashrc
cd /root && \
  echo "# make sure your CC and CXX to new version" >> .bashrc
cd /root && \
  echo "export CXX=/opt/rh/devtoolset-8/root/usr/bin/g++">> .bashrc
cd /root && \
  echo "export CC=/opt/rh/devtoolset-8/root/usr/bin/gcc">> .bashrc

cd /etc/skel && \
  echo "# " >> .bashrc
cd /etc/skel && \
  echo "# gcc 7.5.0 setting for cmake" >> .bashrc
cd /etc/skel && \
  echo "export CMAKE_CXX_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc++" >> .bashrc
cd /etc/skel && \
  echo "export CMAKE_C_COMPILER=/opt/rh/devtoolset-8/root/usr/bin/gcc" >> .bashrc

cd /etc/skel && \
  echo "# " >> .bashrc
cd /etc/skel && \
  echo "# make sure your CC and CXX to new version" >> .bashrc
cd /etc/skel && \
  echo "export CXX=/opt/rh/devtoolset-8/root/usr/bin/g++" >> .bashrc
cd /etc/skel && \
  echo "export CC=/opt/rh/devtoolset-8/root/usr/bin/gcc" >> .bashrc

#
# Install aarch64-linux gnu Version 10.2-2020.11 
#
cd ${HOME}/tmp && \
  aria2c -x10 https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
  unxz gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
  tar xvf gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar -C /usr/local
cd /root && \
  echo "# " >> .bashrc
cd /root && \
  echo "# aarch64-linux-gnu- setting" >> .bashrc
cd /root && \
  echo "export AARCH64_LINUX_GNU_DIR=/usr/local/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu">> .bashrc
cd /root && \
  echo "export PATH=\$AARCH64_LINUX_GNU_DIR/bin:\$PATH" >> .bashrc

cd /etc/skel && \
  echo "# " >> .bashrc
cd /etc/skel && \
  echo "# aarch64-linux-gnu- setting" >> .bashrc
cd /etc/skel && \
  echo "export AARCH64_LINUX_GNU_DIR=/usr/local/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu">> .bashrc
cd /etc/skel && \
  echo "export PATH=\$AARCH64_LINUX_GNU_DIR/bin:\$PATH" >> .bashrc
# In clang command option, please add
# --target=aarch64-linux-gnu -I/usr/include/c++/4.8.2/x86_64-redhat-linux -I/usr/include/c++/4.8.2/x86_64-redhat-linux/bits
