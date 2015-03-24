FROM centos:6.6
MAINTAINER "Daniel Martens" <ddmartens@gmail.com>

RUN yum -y update; yum clean all; yum -y install wget tar unzip openssh-server
RUN yum install -y libaio bc flex net-tools

ADD oracle-xe-11.2.0-1.0.x86_64.rpm.zip /tmp/
RUN cd /tmp/ && \
    unzip oracle-xe-11.2.0-1.0.x86_64.rpm.zip && \
    rm oracle-xe-11.2.0-1.0.x86_64.rpm.zip && \
    mv /usr/bin/free /usr/bin/free.bak && \
    printf "#!/bin/sh\necho Swap - - 2048" > /usr/bin/free && \
    chmod +x /usr/bin/free && \
    mv /sbin/sysctl /sbin/sysctl.bak && \
    printf "#!/bin/sh" > /sbin/sysctl && \
    chmod +x /sbin/sysctl

RUN cd /tmp/Disk1/ && \
    rpm -ihv oracle-xe-11.2.0-1.0.x86_64.rpm

RUN rm -r /tmp/* && \
    rm /usr/bin/bc && \
    mv -f /usr/bin/free.bak /usr/bin/free && \
    mv -f /sbin/sysctl.bak /sbin/sysctl

RUN sed -i -e 's/^\(memory_target=.*\)/#\1/' /u01/app/oracle/product/11.2.0/xe/config/scripts/initXETemp.ora && \
    sed -i -e 's/^\(memory_target=.*\)/#\1/' /u01/app/oracle/product/11.2.0/xe/config/scripts/init.ora && \
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure

RUN ssh-keygen -h -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -h -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    echo "root" | passwd --stdin root && \
    echo "oracle" | passwd --stdin oracle && \
    printf '\
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe \n\
export PATH=$ORACLE_HOME/bin:$PATH \n\
export ORACLE_SID=XE \n\
' >> /etc/bash.bashrc

EXPOSE 22 1521 8080

CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora; \
    /etc/init.d/oracle-xe start; \
    /usr/sbin/sshd -D
