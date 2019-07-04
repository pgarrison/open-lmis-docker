#!/bin/sh

# generate tomcat password if not set
if [ -z "$TOMCAT_PASS" ];
then
    echo Tomcat pass not set, generating...
    export TOMCAT_PASS=`pwgen 8 1`
else
    echo TOMCAT_PASS set, using...
fi

# configure tomcat
if [ -z "$TOMCAT_HOME" ];
then
    echo FATAL ERROR TOMCAT_HOME not set!!!
    exit 1
fi
$TOMCAT_HOME/configureTomcat.sh

# configure open-lmis-manager
/configureOpenLmisManager.sh

su postgres -c "/usr/pgsql-9.6/bin/pg_ctl restart -D /var/lib/pgsql/data/ -swt 300"
su - openlmis -c "export JAVA_HOME=/opt/java/java-se-8u40-ri/;export JAVA_OPTS='-XX:MaxPermSize=256M -DenvironmentName=local -DdefaultLocale=en';/home/openlmis/apache-tomcat/bin/startup.sh"

echo OpenLMIS container now running

while true
do
    sleep 1;
done
