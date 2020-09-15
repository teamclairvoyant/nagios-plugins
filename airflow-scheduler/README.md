# Nagios Plugin for Monitoring Airflow Scheduler

## Description

- The following guide demonstrates how to install a plugin to monitor the Airflow Scheduler through Nagios, an application that monitors systems, networks and infrastructure.

- The plugin returns a CRITICAL state when the scheduler health is "unhealthy" and OK state when the health is "healthy." It returns UNKNOWN state when the API call cannot be made.

## Deployment and Configuration

### Prerequisites

- The process should be running on a machine with the `curl` and `jq` packages installed.

### Note

### Nagios Web Server

- Store the script responsible for monitoring the airflow scheduler (airflow_scheduler.sh) under /usr/local/nagios/etc/libexec/.
- Make the script executable.

```bash
chmod +x /usr/local/nagios/etc/libexec/airflow_scheduler.sh
```

- Create a service definition need for the monitoring service at the end of this file: `/usr/local/nagios/etc/objects/localhost.cfg`.
- Update the values for `airflow_host` (defualt: localhost) and `airflow_port`  (defualt: 8080).

##### Service Definition

```bash

define service{

    use local-service
    host_name localhost

    # service_description Airflow Scheduler <airflow_host>:<airflow_port>
    service_description Airflow Scheduler localhost:8080

    # check_command airflow_scheduler!<airflow_host>!<airflow_port>
    check_command airflow_scheduler!localhost!8080

}

```

### Nagios Agent

- Create a command definition need for the monitoring service at the end of this file: `/usr/local/nagios/etc/objects/commands.cfg`.

##### Command Definition

```bash

define command{

    command_name airflow_scheduler

    command_line $USER1$/airflow_scheduler.sh $ARG1$

}

# $ARG1$ contains the sparkAppName passed through the service definition.
```
- Restart Nagios for the changes to take place (`systemctl restart nagios`).

### Configuration Check

- Ensure the service is visible on the monitoring dashboard accessible at http://[nagios-hostname]/nagios/.

![Nagios Plugin](https://github.com/teamclairvoyant/nagios-plugins/blob/master/spark-streaming/nagios-plugin.png)

## Conclusion

- All done! Now, you should be able to monitor any and all of your spark streaming applications at a glance from the Nagios dashboard.
