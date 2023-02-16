# POC - Airflow process to check delayed executions
This folder holds plugins to monitor airflow dags

### Description
Apache Airflow allows for a set number of Tasks to run in parallel based on configurations. This can be useful to avoid overloading a worker node of cluster. But in the event that a customer or team releases a large number of DAGs that have poor scheduling, this can lead to a lot of tasks being delayed in exuection and adjustments to the cluster and configurations to be made.

Task is to setup a nagios plugin or a general process that can be used to monitor the execution time differences to determine if there is starting to be a large lag.

## Pre-Requisites
- Firstly, Nagios and Airflow have to be setup and running.
- Airflow API is used in these plugins to fetch all the details of dags, tasks. Prior to Airflow 2.0, the Airflow API was experimental: not officially supported or well documented. For the airflow versions 2.x, this is the reference to API documentation
- Enable API by changing the auth_backends in [api] section in airflow.cfg
```
Comma separated list of auth backends to authenticate users of the API. See
# https://airflow.apache.org/docs/apache-airflow/stable/security/api.html for possible values.
# ("airflow.api.auth.backend.default" allows all requests for historic reasons)
auth_backends = airflow.api.auth.backend.session ,airflow.api.auth.backend.basic_auth
```

## Deploying plugin on Nagios
After we setup Nagios, we need to follow these steps to create a python plugin. 

1. First, write the plugin file to plugins folder(this varies with the setup, all values followed here are based of the installation on CentOS7):
``` /usr/local/nagios/libexec/ ```
2. Make it executable using following command
``` chmod +x <path_to_file>/filename.py ```
3. Add this line to nrpe.cfg at /usr/local/nagios/etc/nrpe.cfg
```command[<filename>]=/usr/local/nagios/libexec/<filename>.py ```
4. Add this to /usr/local/nagios/etc/objects/localhost.cfg
```
define service { 
		use generic-service 
		host_name CentOSDroplet
		service_description <Plugin In Python> 								
		check_command <filename> 
	}
```
5. Add this to /usr/local/nagios/etc/objects/commands.cfg
```
define command{
	command_name <filename>	
	command_line $USER1$/<filename> 
	}
```
6. Restart Nagios using 
``` systemctl restart nagios ```
7. These are monitored on the Nagios web interface and will be available at http://<hostname>/nagios

NOTE: Follow these steps for every plugin to deploy on Nagios environment

## Airflow API Health Checks (airflow_health_checks.py)
#### Description
This plugin calls airflow API and sends the API response to the output if there's an error, shows Healthy otherwise.

#### Setup
- Load the plugin file to Nagios plugins location
- The service definition for this plugin is:
```
define service{
  use local-service
  host_name localhost
  service_description Airflow health check using python
  check_command airflow_health_checks!<airflow-host-name>!<port>!<username>!<password>
}
```
- The command definition for this plugins is:
```
define command{
  command_name airflow_health_checks
  command_line $USER1$/airflow_health_checks.py --host=$ARG1$ --port=$ARG2$ --user=$ARG3$ --password=$ARG4$
}
```

## Airflow Failed DAG alerts (airflow_failed_dags.py)
#### Description
This checks for failed dags and displays a critical alert with a list of dags with a failed status

#### Setup
- Load the plugin file to Nagios plugins location
- The service definition for this plugin is:
```
define service{
  use local-service
  host_name localhost
  service_description Airflow failed dag runs using python
  check_command airflow_failed_dags!<airflow-host-name>!<port>!<username>!<password>
}
```
- The command definition for this plugins is:
```
define command{
  command_name airflow_health_checks
  command_line $USER1$/airflow_failed_dags.py --host=$ARG1$ --port=$ARG2$ --user=$ARG3$ --password=$ARG4$
}
```

## Airflow Queued DAGs (airflow_dag_queue_duration.py)
#### Description
This plugin checks for DAGs which are running/queued state for a given period of time and raises alerts when it exceeds the threshold value. The time duration is calculated at task level and output is shown with both dag_id and the task which is delayed in execution

#### Setup
- Load the plugin file to Nagios plugins location
- The service definition for this plugin is:
```
define service{
  use local-service
  host_name localhost
  service_description Airflow dag queue durations using python
  check_command airflow_dag_queue_duration!<airflow-host-name>!<port>!<username>!<password>!<warning_threshold>!<critical_threshold>
}
```
- The command definition for this plugins is:
```
define command{
  command_name airflow_dag_queue_duration
  command_line /usr/local/nagios/libexec/airflow_dag_queue_duration.py --host=$ARG1$ --port=$ARG2$ --user=$ARG3$ --password=$ARG4$ --warning_threshold=$ARG5$ --critical_threshold=$ARG6$
}
```

## Configuration Check
Ensure the service is visible on the monitoring dashboard accessible at http://[nagios-hostname]/nagios/.

## Conclusion
All done! Now, you should be able to monitor any and all of your Airflow DAGs at a glance from the Nagios dashboard.