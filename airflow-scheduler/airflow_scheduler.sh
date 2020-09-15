#!/bin/bash

airflow_host=${1:-localhost}
airflow_port=${2:-8080}

scheduler_status=$(curl -k https://"${airflow_host}":"${airflow_port}"/health | jq --raw-output '.scheduler.status')

if [ "$scheduler_status" = "healthy" ]; then
    exit 0
elif [ "$scheduler_status" = "unhealthy" ]; then
    exit 2
else
    exit 3
fi
