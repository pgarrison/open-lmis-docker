FROM chunky56/openlmis_base
MAINTAINER Chongsun Ahn <chongsun.ahn@villagereach.org>

RUN yum install -y vim sudo && yum clean all

# deploy db
USER root
ADD db /open-lmis-db
WORKDIR /open-lmis-db
ADD build-outputs/pg.dump open_lmis.dump

# configure postgres server
ENV PGPASSWORD p@ssw0rd
ADD docker/postgres/pg_hba.conf /var/lib/pgsql/9.6/data/pg_hba.conf
RUN su postgres -c "/usr/pgsql-9.6/bin/initdb /var/lib/pgsql/data/" && \
    su postgres -c "/usr/pgsql-9.6/bin/pg_ctl start -D /var/lib/pgsql/data/ -swt 300" && \
    su postgres -c "psql --command \"ALTER USER postgres WITH password 'p@ssw0rd'\"" && \
    echo "listen_addresses='*'" >> /var/lib/pgsql/9.6/data/postgresql.conf && \
    /bin/sh loadDb.sh

# get tomcat
ADD docker/tomcat/tomcat.sh /etc/init.d/tomcat
RUN chmod u+x /etc/init.d/tomcat && \
    useradd openlmis && \
    cd /home/openlmis && \
    wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz && \
    tar -xvzf apache-tomcat-7.0.55.tar.gz && \
    rm apache-tomcat-7.0.55.tar.gz && \
    ln -s apache-tomcat-7.0.55 apache-tomcat && \
    chown -R openlmis:openlmis apache-tomcat-7.0.55
ENV TOMCAT_HOME /home/openlmis/apache-tomcat/
ADD docker/tomcat/server.xml /home/openlmis/apache-tomcat/conf/
ADD docker/tomcat/tomcat-users.xml.template $TOMCAT_HOME/conf/
ADD docker/tomcat/configureTomcat.sh $TOMCAT_HOME/
RUN chmod u+x $TOMCAT_HOME/configureTomcat.sh

# get OpenLMIS
ADD build-outputs/openlmis-web.war /home/openlmis/openlmis-web.war
RUN cd /home/openlmis && \
    chown openlmis:openlmis openlmis-web.war && \
    rm -Rf apache-tomcat/webapps/ROOT* && \
    cp openlmis-web.war apache-tomcat/webapps/ROOT.war

# deploy OpenLMIS-Manager
#USER root
#ADD open-lmis-manager /open-lmis-manager
#ADD docker/deployOpenLmisManager.sh /deployOpenLmisManager.sh
#ADD docker/configureOpenLmisManager.sh /configureOpenLmisManager.sh
#WORKDIR /
#RUN /bin/sh deployOpenLmisManager.sh && \
    #chmod u+x configureOpenLmisManager.sh

# Ports for tomcat (8080) and postgresql (5432)
EXPOSE 8080 5432

# set command to run on container start
USER root
ADD docker/start.sh /sbin/start.sh
RUN chmod u+x /sbin/start.sh
WORKDIR /home/openlmis
CMD ["/sbin/start.sh"]
