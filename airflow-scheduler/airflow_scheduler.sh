#!/bin/bash

airflow_webserver_protocol=${1:-http}
airflow_host=${2:-localhost}
airflow_port=${3:-8080}

scheduler_status=$(curl -k "{$airflow_webserver_protocol}"://"${airflow_host}":"${airflow_port}"/health 2>/dev/null | jq --raw-output '.scheduler.status')

echo "Scheduler Status: ${scheduler_status}"

if [ "$scheduler_status" = "healthy" ]; then
    exit 0
elif [ "$scheduler_status" = "unhealthy" ]; then
    exit 2
else
    exit 3
fi
