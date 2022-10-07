# Preface
This repository provides Dockerfile to build Chisel3 development environment with Verilator on CentOS7.

## Dockerfile

See docker/Dockerfile.

## Docker Hub

Everytime making tag(~6 mo), uploading image as well. 
https://hub.docker.com/repository/docker/nsatoshi/centos7-verilator

## How To Build for both Linux and Windows10 users

For your docker build, 

```
$> docker-compose build
```

The contaier build is supporting both x86_64 and arm64 architecture.

| c6i.2xlarge(8xCPU) | c6g.2xlarge(8xCPU)|
|--------------------| ------------------|
| 159m16.698s        | 197m43.996s |

Or you can pull pre-build image from docker hub instead(x86_64 only).
```
$> docker pull nsatoshi/centos7-verilator:latest
```

## How to Start container and ssh login

Start container as daemon mode.
```
$> docker-compose up -d
```

### Linux user
In linux system, you can find which port has been asigned to Docker ssh.
```
export PORT22=`sh -c "docker container port my_verilator 22/tcp | sed -E "1s/^.+://" | head -n 1"`
```

Then ssh connect from your host. user0 password is set to "user0".
```
$> ssh -X -p ${PORT22} user0@localhost
```

Or you can register the ssh connection in your ~/.ssh/config. This is often used for VS Code Remote Explore.
```
Host LocalDocker
    HostName localhost
    User user0
    Port <set your port>
    ForwardX11 yes
    ServerAliveInterval 120
    ServerAliveCountMax 60
```

### Windows 10 user
In windows 10, you can check port the assignment from docker desktop application.

Then ssh connect from your host. Recommending to use [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) as ssh terminal. user0 password is set to "user0".

## Tag History

### 22.10 

- Supporting both x86_64 and aarch64 host.
- docker-compose support.

### 21.12
Adding ssh connection from host, and some of tool update.
Adding aarch64-linux-gnu- for aarch64 linux cross compile.

### v21.01
Initial version.
