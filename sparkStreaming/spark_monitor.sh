#!/bin/bash

sparkAppName=$1

status=$(yarn application -list -appTypes SPARK -appStates RUNNING | grep $sparkAppName)

if [ -z "$status" ]; then

    echo "CRITICAL - $sparkAppName is not running."
    exit 2

else

    echo "OK - $sparkAppName is running."
    exit 0

fi

# Spark Streaming Deployment
# spark2-submit --master yarn --deploy-mode cluster /home/cloudera/Desktop/testSpark.py

# Service Definition
# Path: /usr/local/nagios/etc/objects/localhost.cfg

: <<'END'
define service{
        use local-service
        host_name localhost
        service_description Spark Monitor <filename>
        check_command spark_monitor!<filename>
}
END

# Command Definition
# Path: /usr/local/nagios/etc/objects/commands.cfg

: <<'END'
define command{
        command_name spark_monitor
        command_line $USER1$/spark_monitor.sh $ARG1$
}
END