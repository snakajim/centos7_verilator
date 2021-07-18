# HOW TO build
# $> docker build -t ssh-test .
# HOW TO run
# $> docker run -itd -p 2222:22 ssh-test:latest
# HOW TO connect
# $> ssh -p 2222 user0@localhost
#
# Please refer
# https://pocketcode.net/docker-centos7-ssh-connect
#
FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd sudo git xeyes; yum clean all
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

EXPOSE 22

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN sed -i 's/\r//' /start.sh
RUN ./start.sh
ENTRYPOINT ["/usr/sbin/sshd", "-D"]