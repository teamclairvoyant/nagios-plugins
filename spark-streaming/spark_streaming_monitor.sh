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
