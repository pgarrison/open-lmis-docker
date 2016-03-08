#!/bin/bash
#
# Init file for SixSigns Tomcat server
#
# chkconfig: 2345 55 25
# description: SixSigns Tomcat server
#
#### BEGIN INIT INFO
# Provides: tomcat
# Required-Start: couchdb mysqld activemq
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: tomcat init script
#### END INIT INFO

# Source function library.
source /etc/environment
. /etc/init.d/functions

RUN_AS_USER=openlmis # Adjust run user here
CATALINA_HOME=/home/$RUN_AS_USER/apache-tomcat

start() {
        echo "Starting Tomcat: "
        if [ "x$USER" != "x$RUN_AS_USER" ]; then
          su $RUN_AS_USER -c "export JAVA_OPTS='-XX:MaxPermSize=256M -DenvironmentName=local';$CATALINA_HOME/bin/startup.sh"
        else
          $CATALINA_HOME/bin/startup.sh
        fi
        echo "done."
}
stop() {
        echo "Shutting down Tomcat: "
        if [ "x$USER" != "x$RUN_AS_USER" ]; then
          su $RUN_AS_USER -c "$CATALINA_HOME/bin/shutdown.sh"
        else
          $CATALINA_HOME/bin/shutdown.sh
        fi
        echo "done."
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        stop
        sleep 10
        #echo "Hard killing any remaining threads.."
        #kill -9 `cat $CATALINA_HOME/work/catalina.pid`
        start
        ;;
  *)
        echo "Usage: $0 {start|stop|restart}"
esac

exit 0

