#!/bin/bash
# DESCRIPTION:
# sshd_$OS front end script.
# 
# See also:
# https://docs.docker.jp/engine/examples/running_ssh_service.html
#
UBLUSER="user0"

docker kill cs7_verilator
docker system prune -f

docker build -t nsatoshi/centos7-verilator --build-arg UBLUSER=${UBLUSER} -f Dockerfile . --no-cache
docker run -d -P --name cs7_verilator --hostname cs7 --restart=always nsatoshi/centos7-verilator

#
# check which port is assigned to ssh(22) on the host
#
export PORT22=`sh -c "docker container port cs7_verilator 22/tcp | sed -E "1s/^.+://" | head -n 1"`

#
# check Docker container IP address on the host
#
#docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  cs7_verilator

#
# Preparing key pair for the cs7_verilator container
#
rm ${HOME}/.ssh/id_rsa_localhost_*
sed -i '/^\[localhost\]/d' ${HOME}/.ssh/known_hosts
ssh-keygen -t rsa -N "" -f ${HOME}/.ssh/id_rsa_localhost_${PORT22}

#
# Sending and setting public key to cs7_verilator container under ${HOME}/.ssh
#
echo "Please enter password."
ssh-copy-id -o IdentitiesOnly=yes -p ${PORT22} -i ${HOME}/.ssh/id_rsa_localhost_${PORT22} \
  ${UBLUSER}@localhost

#
# Now you should have ssh connection without password
#
ssh -o IdentitiesOnly=yes -p ${PORT22} -i ${HOME}/.ssh/id_rsa_localhost_${PORT22} \
  ${UBLUSER}@localhost echo "If you can see this msg, ssh login done without passwd. Congras!"

