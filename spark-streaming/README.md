# Nagios Plugin for Monitoring Spark Streaming Applications

## Description

- The following guide demonstrates how to install a plugin to monitor Spark Streaming Applications through Nagios, an application that monitors systems, networks and infrastructure.

- The plugin returns a CRITICAL state when the application is not running and OK state when it is running properly.

## Deployment and Configuration

### Prerequisites

- The process should be running on a machine with the `yarn` command available.

### Note

- If utilizing a Kerberized cluster, ensure that the user running the process has the privileges necessary to obtain an authentication ticket.

### Nagios Web Server

- Store the script responsible for monitoring the spark streaming applications (spark_streaming_monitor.sh) under /usr/local/nagios/etc/libexec/.
- Make the script executable.

```bash
chmod +x /usr/local/nagios/etc/libexec/spark_streaming_monitor.sh
```

- Create a service definition need for the monitoring service.

##### Service Definition

```bash
# Path: /usr/local/nagios/etc/objects/localhost.cfg

define service{

    use local-service
    host_name localhost

    service_description Spark Monitor <sparkAppName>
    # service_description Spark Monitor TestSpark

    check_command spark_monitor!<sparkAppName>
    # check_command spark_monitor!TestSpark

}

# <sparkAppName>: the name of the Spark Streaming Application set through the --name flag when submitting
#                 the application to spark-submit.
```

### Nagios Agent

- Create a command definition need for the monitoring service.

##### Command Definition

```bash
# Path: /usr/local/nagios/etc/objects/commands.cfg

define command{

    command_name spark_monitor

    command_line $USER1$/spark_streaming_monitor.sh $ARG1$

}

# $ARG1$ contains the sparkAppName passed through the service definition.
```
### Configuration Check

- Ensure the service is visible on the monitoring dashboard accessible at http://[nagios-hostname]/nagios/.

![Nagios Plugin](https://github.com/teamclairvoyant/nagios-plugins/blob/master/spark-streaming/nagios-plugin.png)

## Conclusion

- All done! Now, you should be able to monitor any and all of your spark streaming applications at a glance from the Nagios dashboard.
