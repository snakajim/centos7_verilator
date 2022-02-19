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
$> docker run -d -p 20022:22 --name eda --hostname cs7 --restart=always nsatoshi/centos7-verilator:latest
```

In this example port 20022 in host is used to ssh access, you can modify it as you want.


Then ssh connect. user0 password is set to "user0".
```
$> docker port eda 22/tcp
$> ssh -p 20022 user0@localhost
```

## Trouble shooting

If you have ssh connection issue, please test using xeyes-ssh/Dockerfile.

## Tag History

### 22-coming future(wish list)

- Using multi-stage builds to reduce container size(TBD).
- Supporting multi-arch

### 22.02
- Adding supervisord to enable multi service.
- Gcc-9.4/LLVM-13.0.1/binutils-2.34/gdb-9.2/git-2.33.1/cmake-3.18.6 as default tool(under /usr/bin).

### 21.12
Adding ssh connection from host, and some of tool update.
Adding aarch64-linux-gnu- for aarch64 linux cross compile.

### v21.01
Initial version.
