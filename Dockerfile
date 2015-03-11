FROM centos:6.6
MAINTAINER "Daniel Martens" <ddmartens@gmail.com>

RUN yum -y update; yum clean all; yum -y install wget tar unzip

RUN cd /opt/ && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-linux-x64.tar.gz" && \
tar xzf jdk-7u75-linux-x64.tar.gz && rm jdk-7u75-linux-x64.tar.gz

RUN alternatives --install /usr/bin/java java /opt/jdk1.7.0_75/bin/java 20000 && \
alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_75/bin/jar 20000 && \
alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_75/bin/javac 20000 && \
alternatives --install /usr/bin/javaws javaws /opt/jdk1.7.0_75/bin/javaws 20000

RUN cd /tmp/ && wget http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip && \
unzip -d /opt/oracle/ glassfish-4.0.zip && rm -f glassfish-4.0.zip

RUN touch /tmp/password.txt && \
chmod 600 /tmp/password.txt && \
echo "AS_ADMIN_PASSWORD=" > /tmp/password.txt && \
echo "AS_ADMIN_NEWPASSWORD=adminadmin" >> /tmp/password.txt && \
/opt/oracle/glassfish4/glassfish/bin/asadmin --user admin --passwordfile /tmp/password.txt change-admin-password --domain_name domain1 && \
echo "AS_ADMIN_PASSWORD=adminadmin" > /tmp/password.txt && \
/opt/oracle/glassfish4/glassfish/bin/asadmin start-domain && \
/opt/oracle/glassfish4/glassfish/bin/asadmin --interactive=false --user admin --passwordfile /tmp/password.txt enable-secure-admin  && \
/opt/oracle/glassfish4/glassfish/bin/asadmin stop-domain && \
rm /tmp/password.txt

ENV JAVA_HOME /opt/jdk1.7.0_75
ENV JRE_HOME /opt/jdk1.7.0_75

EXPOSE 8080 4848 8181

WORKDIR /opt/oracle/glassfish4/glassfish/bin

CMD /opt/oracle/glassfish4/glassfish/bin/asadmin start-domain --verbose
