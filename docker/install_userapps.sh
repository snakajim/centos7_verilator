#!/bin/bash

# ---------------------------------------------------------------------------------
# Set user ID to be used for
# ---------------------------------------------------------------------------------
UBLUSER=user0
getent passwd | grep -q ${UBLUSER}
ret=$?
if [ $ret == "1" ]; then
  echo "User ID ${UBLUSER} is not found. Program exit."
  exit
fi

#  ---------------------------------------------------------------------------------
# other tools which are recommeded to install as non-root user
#  ---------------------------------------------------------------------------------
#
# SBT/Chisel3
#
# install firrtl v1.4.1
sudo -u ${UBLUSER} sh -c "git clone --depth=1 https://github.com/freechipsproject/firrtl.git -b v1.4.3 \${HOME}/.firrtl"
sudo -u ${UBLUSER} sh -c "cd \${HOME}/.firrtl && sbt compile"
sudo -u ${UBLUSER} sh -c "cd \${HOME}/.firrtl && sbt assembly"
sudo -u ${UBLUSER} sh -c "cd \${HOME} && echo '# adding firrtl path' >> .bashrc"
sudo -u ${UBLUSER} sh -c "cd \${HOME} && echo 'export FIRRTL_PATH=\${HOME}/.firrtl/utils/bin'  >> .bashrc"
sudo -u ${UBLUSER} sh -c "cd \${HOME} && echo 'export PATH=\$FIRRTL_PATH:\$PATH' >> .bashrc"
# install sv2chisel
sudo -u ${UBLUSER} sh -c "git clone --depth=1 https://github.com/ovh/sv2chisel.git \${HOME}/.sv2chisel"
sudo -u ${UBLUSER} sh -c "cd \${HOME}/.sv2chisel && sbt compile"
sudo -u ${UBLUSER} sh -c "cd \${HOME}/.sv2chisel && sbt test"
sudo -u ${UBLUSER} sh -c "cd \${HOME}/.sv2chisel && sbt publishLocal"

#
# install MS VS Code for linux
#
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo yum check-update && sudo yum -y install code
sudo yum clean all
