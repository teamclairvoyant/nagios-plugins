#!/bin/bash

sparkStreamingAppName=$1

status=$(yarn application -list -appTypes SPARK -appStates RUNNING | grep $sparkStreamingAppName)

if [ -z "$status" ]; then

    echo "CRITICAL - $sparkStreamingAppName is not running."
    exit 2

else

    echo "OK - $sparkStreamingAppName is running."
    exit 0

fi
