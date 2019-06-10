# Nagios Plugin for Monitoring Spark Streaming Applications


The following code snippets show how to implement a simple plugin for Nagios to monitor Spark Streaming Applications.

A service and a command definition need to be created for the monitoring service.

```bash

# Path: /usr/local/nagios/etc/objects/localhost.cfg

define service{
use local-service
host_name localhost
service_description Spark Monitor <sparkAppName>
# service_description Spark Monitor TestSpark
check_command spark_monitor!<sparkStreamingFilename>
# check_command spark_monitor!testSpark.py
}
```

[Medium Article Post](https://medium.com/@prakshalj0512/nagios-plugin-for-monitoring-spark-streaming-applications-ea3859b9a275?postPublishedType=repub)

### Service Definition


