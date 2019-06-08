#!/bin/bash

sparkStreamingFilename=$1

if [[ ($sparkStreamingFilename == *.py) || ($sparkStreamingFilename == *.java) || ($sparkStreamingFilename == *.scala) || ($sparkStreamingFilename == *.sc) ]]; then

    status=$(yarn application -list -appTypes SPARK -appStates RUNNING | grep $sparkStreamingFilename)

    if [ -z "$status" ]; then

        echo "CRITICAL - $sparkStreamingFilename is not running."
        exit 2

    else

        echo "OK - $sparkStreamingFilename is running."
        exit 0

    fi

else

    echo "CRITICAL - Spark Streaming Filename is invalid."
    exit 2

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
        check_command spark_monitor!<sparkStreamingFilename>
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
