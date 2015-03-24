FROM centos:6.6
MAINTAINER "Daniel Martens" <ddmartens@gmail.com>

RUN yum -y update; yum clean all; yum -y install wget tar unzip openssh-server
RUN yum install -y libaio bc flex

ADD oracle-xe-11.2.0-1.0.x86_64.rpm.zip /
RUN unzip oracle-xe-11.2.0-1.0.x86_64.rpm.zip && \
    rm oracle-xe-11.2.0-1.0.x86_64.rpm.zip && \
    cd Disk1 && \
    yum localinstall -y oracle-xe-11.2.0-1.0.x86_64.rpm

RUN printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure


