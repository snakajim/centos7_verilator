#!/bin/bash
# DESCRIPTION:
# sshd_$OS front end script.
# 
# See also:
# https://docs.docker.jp/engine/examples/running_ssh_service.html
#

OS=centos7
#OS=focal

docker kill sshd_$OS
docker system prune -f 

# docker build and run
if [ $OS = "centos7" ]; then
  docker build -t sshd_$OS -f Dockerfile.$OS .
  docker run -d --hostname test_sshd -P --name test_sshd --privileged sshd_$OS  
else
  docker build -t sshd_$OS -f Dockerfile .
  docker run -d --hostname test_sshd -P --name test_sshd sshd_$OS  
fi

# check which port is assigned to ssh(22) on the host
export PORT22=`sh -c "docker container port test_sshd 22/tcp | sed -E "1s/^.+://" | head -n 1"`
# check Docker container IP address on the host
#docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  test_sshd

if [ $OS = "centos7" ]; then
  ssh -p $PORT22 user0@localhost
else
  ssh -p $PORT22 user0@localhost
fi