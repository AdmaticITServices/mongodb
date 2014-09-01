FROM ubuntu:trusty
MAINTAINER Anbarasan Murthy <anbarasan_m@admatic.in>

RUN apt-get update 
RUN apt-get -y install aptitude
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen
RUN mkdir -p /data/db

# install ssh server
RUN apt-get -y install openssh-server; mkdir -p /var/run/sshd; locale-gen en_US en_US.UTF-8

# install supervisor
# RUN aptitude -y install supervisor
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /var/log/supervisor

RUN apt-get install -y python-pip && pip install supervisor-stdout

# Add run scripts
ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh
RUN chmod 755 ./*.sh

# set root password
RUN echo 'root:admatic' |chpasswd
RUN sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config

EXPOSE 27017 28017 22

#CMD ["/run.sh"]
# run container with supervisor
CMD ["/usr/bin/supervisord"]
