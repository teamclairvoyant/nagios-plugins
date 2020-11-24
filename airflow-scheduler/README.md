# Nagios Plugin for Monitoring Airflow Scheduler

## Description

- The following guide demonstrates how to install a plugin to monitor the Airflow Scheduler through Nagios, an application that monitors systems, networks and infrastructure.

- The plugin returns a CRITICAL state when the scheduler health is "unhealthy" and OK state when the health is "healthy." It returns UNKNOWN state when the API call cannot be made.

## Deployment and Configuration

### Prerequisites

- The process should be running on a machine with the `curl` and `jq` packages installed.

- Debian/Ubuntu
```
sudo apt install -y curl
sudo apt install -y jq
```

- CentOS
```
sudo yum install -y curl
sudo yum install -y epel-release
sudo yum install -y jq
```

- Binaries
```
# Curl
sudo su
cd /usr/local/src
rm -rf curl*
wget https://curl.haxx.se/download/curl-7.70.0.zip
unzip curl-7.70.0.zip
cd curl-7.70.0
./configure --with-ssl --with-zlib --with-gssapi --enable-ldap --enable-ldaps --with-libssh --with-nghttp2
make
make install

#Jq
sudo apt-get install -y libtool
git clone https://github.com/stedolan/jq.git
cd jq
autoreconf -i
./configure --disable-maintainer-mode
make
sudo make install
```

### Nagios Web Server

- Store the script responsible for monitoring the airflow scheduler (airflow_scheduler.sh) under /usr/local/nagios/etc/libexec/.
- Make the script executable.

```bash
chmod +x /usr/local/nagios/etc/libexec/airflow_scheduler.sh
```

- Create a service definition need for the monitoring service at the end of this file: `/usr/local/nagios/etc/objects/localhost.cfg`.
- Update the values for `airflow_webserver_protocol` (default: http), `airflow_host` (defualt: localhost), and `airflow_port`  (defualt: 8080).

##### Service Definition

```bash

define service{

    use local-service
    host_name localhost

    # service_description Airflow Scheduler <airflow_host>:<airflow_port>
    service_description Airflow Scheduler http://localhost:8080

    # check_command airflow_scheduler!<airflow_webserver_protocol>!<airflow_host>!<airflow_port>
    check_command airflow_scheduler!http!localhost!8080
}

```

### Nagios Agent

- Create a command definition need for the monitoring service at the end of this file: `/usr/local/nagios/etc/objects/commands.cfg`.
- Pass the following three arguments:
  - `$ARG1$` : airflow webserver protocol (e.g. `http` or `https`)
  - `$ARG2$` : airlfow host
  - `$ARG3$` : airflow port (e.g. `8080`)

##### Command Definition

```bash

define command{

    command_name airflow_scheduler

    command_line $USER1$/airflow_scheduler.sh $ARG1$ $ARG2$ $ARG3$
}


```
- Restart Nagios for the changes to take place (`systemctl restart nagios`).

### Configuration Check

- Ensure the service is visible on the monitoring dashboard accessible at http://[nagios-hostname]/nagios/.

## Conclusion

- All done! Now, you should be able to monitor any and all of your Airflow schedulers at a glance from the Nagios dashboard.
