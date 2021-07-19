#!/bin/bash
docker build -t xeyes_ssh .

docker kill xeyes
docker system prune -f 

docker run --rm -it \
  --net host \
  -e DISPLAY=unix${DISPLAY} \
  -v /tmp/.X-unix:/tmp/.X-unix \
  -v $HOME/.Xauthority:/root/.Xauthority \
  --name xeyes \
  xeyes_ssh
