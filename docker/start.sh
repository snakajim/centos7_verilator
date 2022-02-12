#!/bin/bash

# ---------------------------------------------------------------------------------
# user0 add with sudo authority
# ---------------------------------------------------------------------------------
UBLUSER=user0
useradd -m ${UBLUSER}
usermod -aG wheel ${UBLUSER}
chsh -s /bin/bash ${UBLUSER}
echo ${UBLUSER}:${UBLUSER} | chpasswd
# change setting for ${UBLUSER} & wheel group
sed -i -E 's/\#auth\s+required\s+pam_wheel\.so\s+use_uid/auth      required      pam_wheel\.so      use_uid/' /etc/pam.d/su
sed -i -E "s/# %wheel\s+ALL=\(ALL\)\s+NOPASSWD:\s+ALL/%wheel        ALL=(ALL)       NOPASSWD: ALL /" /etc/sudoers

# ---------------------------------------------------------------------------------
# ${UBLUSER} ssh key pair setting
# ---------------------------------------------------------------------------------
sudo -u ${UBLUSER} sh -c "mkdir -p \${HOME}/.ssh"
sudo -u ${UBLUSER} sh -c "touch \${HOME}/.ssh/authorized_keys"
sudo -u ${UBLUSER} sh -c "ssh-keygen -t rsa -f \${HOME}/.ssh/id_rsa_docker_${UBLUSER} -N '' "
sudo -u ${UBLUSER} sh -c "cat \${HOME}/.ssh/id_rsa_docker_${UBLUSER}.pub >> \${HOME}/.ssh/authorized_keys" 
sudo -u ${UBLUSER} sh -c "chmod 600 \${HOME}/.ssh/authorized_keys"

#  ---------------------------------------------------------------------------------
# other tools which are recommeded to install as non-root user
#  ---------------------------------------------------------------------------------
#
# SBT/Chisel3
#
# set gcc to 8
sudo -u ${UBLUSER} sh -c "scl enable devtoolset-8 bash"
sudo -u ${UBLUSER} sh -c "mkdir -p \${HOME}/work/MyProject"
sudo -u ${UBLUSER} sh -c "mkdir -p \${HOME}/tmp"
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
