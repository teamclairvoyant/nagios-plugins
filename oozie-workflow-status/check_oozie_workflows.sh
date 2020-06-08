#!/usr/bin/env bash
HOST=`echo $1 | tr ‘[:upper:]’ ‘[:lower:]’`
PORT=$2
JAVA_HOME=$3
SEC_ENABLED=$4
if [[ “$SEC_ENABLED” == “true” ]]; then
  NAGIOS_KEYTAB=$5
  NAGIOS_USER=$6
  KINIT_PATH=$7
  TIME_RANGE=$8
  HISTORY_LENGTH=$9
  out1=`${KINIT_PATH} -kt ${NAGIOS_KEYTAB} ${NAGIOS_USER} 2>&1`
  if [[ “$?” -ne 0 ]]; then
    echo “CRITICAL: Error doing kinit for nagios [$out1]“;
    exit 2;
  fi
else
  TIME_RANGE=$5
  HISTORY_LENGTH=$6
fi
out=`python $( dirname ${BASH_SOURCE[0]} )/check_oozie_workflows.py $HOST $PORT $JAVA_HOME $SEC_ENABLED $TIME_RANGE $HISTORY_LENGTH 2>&1`;
rc=$?;
echo $out;
exit $rc;
