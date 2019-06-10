# Nagios Plugin for Monitoring Spark Streaming Applications

## Description

- The following guide demonstrates how to install a plugin is to monitor Spark Streaming Applications through Nagios, an application that monitors systems, networks and infrastructure.

- The plugin returns a CRITICAL state when the application is not running and OK state when it is running properly.



[Follow Along Medium Post](https://medium.com/@prakshalj0512/nagios-plugin-for-monitoring-spark-streaming-applications-ea3859b9a275?postPublishedType=repub)


## Deployment and Configuration

### Prerequisites

- YARN Application Manager

### Note

- If utilizing Kerberos, ensure that the user running the process has the privileges necessary to obtain an authentication ticket.

#### Nagios WebServer

- Store the script under /usr/local/nagios/etc/libexec/ found here.
- Make the script executable.


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

![Nagios Plugin](https://github.com/teamclairvoyant/nagios-plugins/blob/master/spark-streaming/nagios-plugin.png)