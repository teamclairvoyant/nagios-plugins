# Nagios Plugin for Monitoring Spark Streaming Applications


The following code snippets show how to implement a simple plugin for Nagios to monitor Spark Streaming Applications.

A service and a command definition need to be created for the monitoring service.

[Medium Article Post](https://medium.com/@prakshalj0512/nagios-plugin-for-monitoring-spark-streaming-applications-ea3859b9a275?postPublishedType=repub)

### Service Definition

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

### Command Definition

```bash
# Path: /usr/local/nagios/etc/objects/commands.cfg

define command{
command_name spark_monitor
command_line $USER1$/spark_monitor.sh $ARG1$
}
```
### Monitoring Script

The source code for the shell script can be found in the GitHub repository (spark_monitor.sh). It returns CRITICAL state when the application is not running or the extension of the filename being submitted is invalid, and OK state when it is running properly. The file should be stored under /usr/local/nagios/etc/libexec/ for Nagios to properly access it.

### Configuration Check

Once the files are properly modified, the service can be located on the monitoring dashboard, accessible at http://localhost/nagios.

![alt text](https://raw.githubusercontent.com/username/projectname/branch/path/to/img.png)