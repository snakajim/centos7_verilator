#!/bin/bash
# DESCRIPTION:
# sshd_$OS front end script.
# 
# See also:
# https://docs.docker.jp/engine/examples/running_ssh_service.html
#

OS=centos7
#OS=focal

docker kill test_sshd
docker system prune -f 

# docker build and run
if [ $OS = "centos7" ]; then
  docker build -t sshd_$OS -f Dockerfile.$OS .
  docker run -d --hostname test_sshd -P --name test_sshd --privileged sshd_$OS  
else
  docker build -t sshd_$OS -f Dockerfile .
  docker run -d --hostname test_sshd -P --name test_sshd sshd_$OS  
fi

#
# check which port is assigned to ssh(22) on the host
#
export PORT22=`sh -c "docker container port test_sshd 22/tcp | sed -E "1s/^.+://" | head -n 1"`

#
# check Docker container IP address on the host
#
#docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  test_sshd

#
# Preparing key pair for the test_sshd container
#
rm ${HOME}/.ssh/id_rsa_localhost_*
sed -i '/^\[localhost\]/d' ${HOME}/.ssh/known_hosts
ssh-keygen -t rsa -N "" -f ${HOME}/.ssh/id_rsa_localhost_${PORT22}

#
# Sending and setting public key to the test_sshd container under /home/user0/.ssh
#
scp -o IdentitiesOnly=yes -P ${PORT22} ${HOME}/.ssh/id_rsa_localhost_${PORT22}.pub \
  user0@localhost:/home/user0/.ssh/
ssh -o IdentitiesOnly=yes -p ${PORT22} user0@localhost \
  "cat /home/user0/.ssh/id_rsa_localhost_${PORT22}.pub >> /home/user0/.ssh/authorized_keys"
ssh -o IdentitiesOnly=yes -p ${PORT22} user0@localhost \
  "chmod 600 /home/user0/.ssh/*"

#
# Now you should have ssh connection without password
#
ssh -o IdentitiesOnly=yes -p ${PORT22} -i ${HOME}/.ssh/id_rsa_localhost_${PORT22} \
  user0@localhost echo "If you can see this msg, ssh login done without passwd. Congras!"

