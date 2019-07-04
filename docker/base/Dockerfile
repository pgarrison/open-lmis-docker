FROM centos:centos7
MAINTAINER Josh Zamor <josh.zamor@villagereach.org>

# install packages
RUN rpm -Uvh http://yum.postgresql.org/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum update -y && \
    yum reinstall -y glibc-common && \
    yum install -y postgresql96-server postgresql96-contrib && \
    yum install -y tar bzip2 unzip wget which git && \
    yum install -y epel-release && \
    rpm --import https://fedoraproject.org/static/0608B895.txt && \
    yum install -y pwgen && \
    yum install -y npm && \
    yum clean all

RUN  mkdir /opt/java && \
    cd /opt/java && \
    wget https://download.java.net/openjdk/jdk8u40/ri/jdk_ri-8u40-b25-linux-x64-10_feb_2015.tar.gz && \
    tar -xvzf jdk_ri-8u40-b25-linux-x64-10_feb_2015.tar.gz && \
    rm *.tar.gz && \
    ln -s jdk1.7.0_55/ current
ENV JAVA_HOME /opt/java/current/
ENV PATH $PATH:/opt/java/current/bin

# grunt command line tools
RUN npm install -g grunt-cli
