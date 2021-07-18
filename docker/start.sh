#!/bin/bash

# ---------------------------------------------------------------------------------
# user0 add with sudo authority
# ---------------------------------------------------------------------------------
useradd -m user0
usermod -aG wheel user0
chsh -s /bin/bash user0
echo "user0:user0" | chpasswd
echo "root:root"   | chpasswd
# change setting for user0 & wheel group
sed -i -E 's/\#auth\s+required\s+pam_wheel\.so\s+use_uid/auth      required      pam_wheel\.so      use_uid/' /etc/pam.d/su
sed -i -E "s/# %wheel\s+ALL=\(ALL\)\s+NOPASSWD:\s+ALL/%wheel        ALL=(ALL)       NOPASSWD: ALL /" /etc/sudoers

# ---------------------------------------------------------------------------------
# user0 ssh key pair setting
# ---------------------------------------------------------------------------------
sudo -u user0 sh -c "mkdir -p \${HOME}/.ssh"
sudo -u user0 sh -c "touch \${HOME}/.ssh/authorized_keys"
sudo -u user0 sh -c "ssh-keygen -t rsa -f \${HOME}/.ssh/id_rsa_docker_user0 -N '' "
sudo -u user0 sh -c "cat \${HOME}/.ssh/id_rsa_docker_user0.pub >> \${HOME}/.ssh/authorized_keys" 
sudo -u user0 sh -c "chmod 600 \${HOME}/.ssh/authorized_keys"

#  ---------------------------------------------------------------------------------
# other tools which are recommeded to install as non-root user
#  ---------------------------------------------------------------------------------
#
# SBT/Chisel3
#
# set gcc to 8
sudo -u user0 sh -c "scl enable devtoolset-8 bash"
sudo -u user0 sh -c "mkdir -p \${HOME}/work/MyProject"
sudo -u user0 sh -c "mkdir -p \${HOME}/tmp"
# install firrtl v1.4.1
sudo -u user0 sh -c "git clone --depth=1 https://github.com/freechipsproject/firrtl.git -b v1.4.3 \${HOME}/.firrtl"
sudo -u user0 sh -c "cd \${HOME}/.firrtl && sbt compile"
sudo -u user0 sh -c "cd \${HOME}/.firrtl && sbt assembly"
sudo -u user0 sh -c "cd \${HOME} && echo '# adding firrtl path' >> .bashrc"
sudo -u user0 sh -c "cd \${HOME} && echo 'export FIRRTL_PATH=\${HOME}/.firrtl/utils/bin'  >> .bashrc"
sudo -u user0 sh -c "cd \${HOME} && echo 'export PATH=\$FIRRTL_PATH:\$PATH' >> .bashrc"
# install sv2chisel
sudo -u user0 sh -c "git clone --depth=1 https://github.com/ovh/sv2chisel.git \${HOME}/.sv2chisel"
sudo -u user0 sh -c "cd \${HOME}/.sv2chisel && sbt compile"
sudo -u user0 sh -c "cd \${HOME}/.sv2chisel && sbt test"
sudo -u user0 sh -c "cd \${HOME}/.sv2chisel && sbt publishLocal"

#
# Downlaod ACL v21.05, dependencies and patching ComputeLibrary/SConstruct for cross compile.
#
sudo -u user0 sh -c "mkdir -p \${HOME}/acl && cd \${HOME}/acl && git clone --depth=1 https://github.com/ARM-software/ComputeLibrary.git -b v21.05"
sudo -u user0 sh -c "cd \${HOME}/acl/ComputeLibrary && perl -pe 's/armv8\.2-a\+fp16'/armv8\.2-a\+fp16\+dotprod'/g' -i ./SConstruct"
sudo -u user0 sh -c "cd \${HOME}/acl/ComputeLibrary && perl -pe 's/aarch64-linux-gnu-/aarch64-none-linux-gnu-/g' -i ./SConstruct"

#
# Plenv to switch perl version
# https://github.com/tokuhirom/plenv.git
#
sudo -u user0 sh -c "git clone --depth=1 -b 2.3.1 https://github.com/tokuhirom/plenv.git \${HOME}/.plenv"
sudo -u user0 sh -c "git clone --depth=1 -b 1.32 https://github.com/tokuhirom/Perl-Build.git \${HOME}/.plenv/plugins/perl-build/"
sudo -u user0 sh -c "cd \${HOME} && echo '# adding plenv path' >> .bash_profile"
sudo -u user0 sh -c "cd \${HOME} && echo 'export PATH=\${HOME}/.plenv/bin:\$PATH' >> .bash_profile"
sudo -u user0 sh -c "cd \${HOME} && echo 'eval "$(\${HOME}/.plenv/bin/plenv init -)"' >> .bash_profile"

#
# install MS VS Code for linux
#
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo yum check-update && sudo yum -y install code
sudo yum clean all
