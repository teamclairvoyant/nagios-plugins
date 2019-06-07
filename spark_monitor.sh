#!/bin/bash

sparkAppName=$1

x=$(yarn application -list -appTypes SPARK -appStates RUNNING | grep $sparkAppName)

if [ -z "$x" ]; then

    echo "$sparkAppName is not running."
    exit 2

else

    echo "$x"
    echo "$sparkAppName is running."
    exit 0

fi

# Spark Streaming Deployment
# spark2-submit --master yarn --deploy-mode cluster /home/cloudera/Desktop/testSpark.py

# Service Definition
# Path: /usr/local/nagios/etc/objects/localhost.cfg

'''
define service{
        use local-service
        host_name localhost
        service_description Spark Monitor <filename>
        check_command spark_monitor!<filename>
        check_interval 10s
        retry_interval 1
}
'''

# Command Definition
# Path: /usr/local/nagios/etc/objects/commands.cfg

'''
define command{
        command_name spark_monitor
        command_line $USER1$/spark_monitor.sh $ARG1$
}
'''