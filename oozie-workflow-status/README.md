###Hortonworks Data Platform 3.1.1 Nagios Plugin - Oozie Workflow Status

This plugin will identify and alert the status of Oozie workflows.
This is assumed that nagios server and nrpe plugins have been installed, up and running. If not then follow the steps mentioed in link provided as below.

https://github.com/teamclairvoyant/nagios-plugins/blob/master/oozie-workflow-status/Nagios%20installation%20and%20configuration

Oozie nagios screenshot.PNG


###News
Updated for HDP 3.1.1 Nagios integration.
This plugin now only reports on a fixed number of jobs in the past that meet time range criteria specified by the admin.

###Dependencies
If your cluster is kerberos enabled then, the Python source will need three new packages installed on the Nagios server.
python-kerberos (CentOS Base)
python-urllib2_kerberos (EPEL)
pytz (CentOS Base)

If you are using Ubuntu then first install python 2.7.12 or later with pip.
Run command  
pip install python-urllib2
pip install python-kerberos
pip install pytz 


###Tested
HDP 3.1.1 with Ambari version 2.7.3.0 

###Installation
All actions are conducted on the Standaone Nagios server. 

**Read Carefully** -- The only files that should be added are check_oozie_workflows{.py,.sh} on Nagios server to location "/usr/local/nagios/libexec/".  The other files are configurations that should be added to the existing custom configuration.

1. Add [check_oozie_workflows.py] and [check_oozie_workflows.sh] to the Nagios server directory at: //usr/local/nagios/libexec/
2. Configure Ooze server host group and host, oozie service group and oozie service, at location : /usr/local/nagios/etc/server/host_groups.cfg, /usr/local/nagios/etc/server/hosts.cfg, /usr/local/nagios/etc/server/service_groups.cfg, /usr/local/nagios/etc/server/services.cfg, and define oozie command at location: /usr/local/nagios/etc/objects/commands.cfg

Example for host_groups.cfg  add config mentioned below at the end of the config file.

define hostgroup{
        hostgroup_name  oozie-server
        alias           oozie-server
}


 For hosts.cfg  make oozie server host member of oozie group. 
 
Example: 

define host {
        use                     linux-server
        host_name               test1.server.com
        alias                   Oozie-server host
        address                 XX.XX.XX.XX.XX
        hostgroups              oozie-server
}

```

3. Define command for oozie workflow status  at location "/usr/local/nagios/etc/objects/commands.cfg" and add below command as it is. 


define command{
  command_name    check_oozie_workflows
  command_line    $USER1$/check_oozie_workflows.sh $HOSTADDRESS$ 11000 java64_home false 5 500
}

4. Once command is defined it's time to configure service group for oozie workflow status. Add below config at the end of file "/usr/local/nagios/etc/server/service_groups.cfg"

define servicegroup{
        servicegroup_name  oozie
        alias              oozie
}


Now in configure service for oozie. add below cobfig at the end of file "/usr/local/nagios/etc/server/services.cfg"


define service {
        hostgroup_name          oozie-server
        use                     generic-service
        service_description     oozie::Oozie Workflow status
        servicegroups           oozie
        check_command           check_oozie_workflows!{{ oozie_server_port }}!{{ java64_home }}!false
        normal_check_interval   1
        retry_check_interval    1
        max_check_attempts      3
}



5. Restart Nagios server  for changes to take effect. 

service nagios restart 

service nagios status 




####Alert Translations

|Oozie Status   |  Script Exit Code |  Nagios Level |
| ------------- |:-----------------:|--------------:|
|FAILED         |     2             |    CRITICAL   |
|KILLED         |     1             |    WARNING    |
|SUSPENDED      |     1             |    WARNING    |
|SUCCEEDED      |     0             |    OK         |
|all others     |     0             |    OK         |

###################################Awesome############### 
