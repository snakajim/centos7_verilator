FROM ubuntu

RUN apt-get -y update; apt-get install -y xterm; apt-get clean
RUN apt-get -y install openssh-server x11-apps; apt-get clean
RUN sed -i 's/^#Port 22/Port 20022/' /etc/ssh/sshd_config
RUN sed -i 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#X11DisplayOffset 10/X11DisplayOffset 10/' /etc/ssh/sshd_config
RUN sed -i 's/^#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config
RUN echo "AddressFamily inet"  >> /etc/ssh/sshd_config
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN echo "root:root"   | chpasswd

EXPOSE 20022

#
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
