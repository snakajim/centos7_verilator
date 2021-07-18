# Preface
This repository provides Dockerfile to build Chisel3 development environment with Verilator on CentOS7.

## Dockerfile

See docker/Dockerfile.

## Docker Hub

Everytime making tag(~6 mo), uploading image as well. 
https://hub.docker.com/repository/docker/nsatoshi/centos7-verilator

## How To run

Start docker. 

```
$> docker run -it -p 20022:22 -e DISPLAY=$DISPLAY --name eda --hostname cs7 --restart=always -d --net host nsatoshi/centos7-verilator:latest sh
```

In this example port 20022 in host is used to ssh access, you can modify it as you want.


Then ssh connect. user0 password is set to "user0".
```
$> ssh -p 20022 user0@localhost
```

## Trouble shooting

If you have ssh connection issue, please test using test/Dockerfile.

## History

### v21-coming future

Using multi-stage builds to reduce container size(TBD).

### v21.07
Adding ssh connection, and some of tool update.

### v21.01
Initial version.
