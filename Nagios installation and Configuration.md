Why, Need of Continuous Monitoring?

It detects any network or server problems
It determines the root cause of any issues
It maintains the security and availability of the service
It monitors and troubleshoot server performance issues
It allows us to plan for infrastructure upgrades before outdated systems cause failures
It can respond to issues at the first sign of a problem
It can be used to automatically fix problems when they are detected
It ensures IT infrastructure outages have a minimal effect on your organization’s bottom line
It can monitor your entire infrastructure and business processes.


What is Nagios?

Nagios is used for Continuous monitoring of systems, applications, services, and business processes etc in a DevOps culture.

Nagios can alert technical staff of the problem.
Allowing them to begin remediation processes before outages affect business processes, end-users, or customers.
With Nagios, you don’t have to explain why an unseen infrastructure outage affect your organization’s bottom line.


Architecture





Nagios is built on a server/agents architecture.
Usually, on a network, a Nagios server is running on a host, and Plugins interact with local and all the remote hosts that need to be monitored.
These plugins will send information to the Scheduler, which displays that in a GUI.


NRPE (Nagios Remote Plugin Executor)





The NRPE addon is designed to allow you to execute Nagios plugins on remote Linux/Unix machines.
The main reason for doing this is to allow Nagios to monitor “local” resources (like CPU load, memory usage, etc.) on remote machines.
These public resources are not usually exposed to external machines, an agent like NRPE must be installed on the remote Linux/Unix machines.
The check_nrpe plugin, resides on the local monitoring machine.
The NRPE daemon, runs on the remote Linux/Unix machine.
There is a SSL (Secure Socket Layer) connection between monitoring host and remote host as shown in the diagram above.


How it Works





Nagios runs on a server, usually as a daemon or a service.
It periodically runs plugins residing on the same server.
They contact hosts or servers on your network or on the internet.
One can view the status information using the web interface.
You can also receive email or SMS notifications if something happens.
The Nagios daemon behaves like a scheduler that runs certain scripts at certain moments.
It stores the results of those scripts and will run other scripts if these results change.
      Plugins: These are compiled executables or scripts (Perl scripts, shell scripts, etc.) that can be run from a command line to check the status or a host or service. Nagios uses the results from the plugins to determine the current status of the hosts and services on your network.



Nagios Installation (Nagios Core & NRPE)

Four Phases of Nagios Installation.

Step-01 : Install Required Packages In The Monitoring Server.

Step-02 : Install Nagios Core, Nagios Plugins And NRPE (Nagios Remote Plugin Executor).

Step-03 : Set Nagios Password To Access The Web Interface.

Step-04 : Install NRPE In Client Host.


1. Nagios Core 4.3.4 and Nagios Plugins 2.2.1

2. This documentation is broken up into two distinct sections:
                              A. Install Nagios Core
                              B. Install Nagios Plugins

3. This separation is to make a clear distinction as to what prerequisite packages are required by the OS it is being installed on. For example the SNMP packages are installed as part of the Nagios Plugins section, as SNMP is not required by Nagios Core.

Step-1 Prequisites

1. # sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
    # setenforce 0

2. install required packages
# yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel perl

Step-2 Installing nagios-Core

3. Download the nagios core
# cd /tmp
# wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz
# tar xzf nagioscore.tar.gz

4. Compile the code as its source
# cd /tmp/nagioscore-nagios-4.3.4/
# ./configure
# make all

5. Create user & group
This creates the nagios user and group. The apache user is also added to the nagios group.
# useradd nagios
# usermod -a -G nagios apache

6. Install Binaries
This step installs the binary files, CGIs, and HTML files.
# make install

7. Install Service / Daemon
This installs the service or daemon files and also configures them to start on boot.
The Apache httpd service is also configured at this point.

# make install-init
# chkconfig --add nagios
# chkconfig --level 2345 httpd on

8. Install Command Mode
This installs and configures the external command file.
# make install-commandmode

9. Install Configuration Files
This installs the *SAMPLE* configuration files. These are required as Nagios needs some configuration files to allow it to start.
# make install-config

10. Install Apache Config Files
This installs the Apache web server configuration files. Also configure Apache settings if required.
# make install-webconf

11. Configure Firewall
You need to allow port 80 inbound traffic on the local firewall so you can reach the Nagios Core web interface.

# iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
# service iptables save
# ip6tables -I INPUT -p tcp --destination-port 80 -j ACCEPT
# service ip6tables save

12. Create nagiosadmin User Account
You'll need to create an Apache user account to be able to log into Nagios.
The following command will create a user account called nagiosadmin and you will be prompted to provide a password for the account.

# htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

13. Start Apache Web Server
# service httpd start

14. Start Service / Daemon
This command starts Nagios Core.
# service nagios start

15. Test Nagios
Nagios is now running, to confirm this you need to log into the Nagios Web Interface.
Point your web browser to the ip address or FQDN of your Nagios Core server, for example:

http://localhost/nagios

http://public-ip or private-ip/nagios (Note:- Depending on your N/W Architecture)

You will be prompted for a username and password.

The username is nagiosadmin (you created it in a previous step) and the password is what you provided earlier.
Once you have logged in you are presented with the Nagios interface.
Congratulations you have installed Nagios Core.


Step-3 Installing Nagios Plugins

16. Installing The Nagios Plugins
Nagios Core needs plugins to operate properly. The following steps will walk you through installing Nagios Plugins.

Please note that the following steps install most of the plugins that come in the Nagios Plugins package.
However there are some plugins that require other libraries which are not included in those instructions. Please refer to the following KB article for detailed installation instructions:

Prequisites
Make sure that you have the following packages installed.

# yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
# yum install -y perl-Net-SNMP
# cd /tmp
# wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.60.tar.gz
# tar xzf autoconf-2.60.tar.gz
# cd /tmp/autoconf-2.60
# ./configure
# make
# make install

17. Downloading the Source
# cd /tmp
# wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
# tar zxf nagios-plugins.tar.gz

18. Compile + Install
# cd /tmp/nagios-plugins-release-2.2.1/
# ./tools/setup
# ./configure
# make
# make install

19. Test Plugins
Point your web browser to the ip address or FQDN of your Nagios Core server, for example:

http://local/nagios

http://public-ip or private-ip/nagios (Note:- Depending on your N/W Architecture)

Go to a host or service object and "Re-schedule the next check" under the Commands menu. The error you previously saw should now disappear and the correct output will be shown on the screen.

20. Service / Daemon Commands
Different Linux distributions have different methods of starting / stopping / restarting / status Nagios.



# service nagios start
# service nagios stop
# service nagios restart
# service nagios status


Step - 4 NRPE Installation

21. Installing NRPE Using the Install Script
You must run the following commands as root.
# cd /tmp
# wget http://assets.nagios.com/downloads/nagiosxi/agents/linux-nrpe-agent.tar.gz
# tar xzf linux-nrpe-agent.tar.gz
# cd linux-nrpe-agent
# ./fullinstall

22. The script takes care of the following setup:

Installs prerequisite packages
Creates required users and groups
Defines services for xinetd
Compiles and installs the NRPE agent and Nagios plugins
Configures the firewall (except on SLES)
Configures the agent
The script will stop to prompt you once to ask for the IP address(es) for your monitoring server(s).

You will need to type either a single address or multiple addresses separated by spaces. This will configure the xinetd superdaemon to allow connections from those addresses to the NRPE agent.

You now have NRPE installed. You may remove any installation files in the tmp directory.



Step - 5 Set up Mail alerts notification for Nagios.

Once Nagios server and Agent setup completed  we need to set up email alerting for Nagios alerts. You can set up email alert notification as below 

# vi  /usr/local/nagios/etc/objects/commands.cfg   and add below configuration. 

define command {
command_name notify-host-by-email
command_line /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\nHost: $HOSTNAME$\nState: $HOSTSTATE$\nAddress: $HOSTADDRESS$\nInfo: $HOSTOUTPUT$\n\nDate/Time: $LONGDATETIME$\n" | mailx -r "nagiosadmin@sboxdc.com" -s "** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **" --set email-smtp.eu-west-1.amazonaws.com:587 <email-address>
}


define command {

command_name notify-service-by-email
command_line /usr/bin/printf "%b" "***** Nagios *****\n\nNotification Type: $NOTIFICATIONTYPE$\n\nService: $SERVICEDESC$\nHost: $HOSTALIAS$\nAddress: $HOSTADDRESS$\nState: $SERVICESTATE$\n\nDate/Time: $LONGDATETIME$\n\nAdditional Info:\n\n$SERVICEOUTPUT$\n" | mailx -r "nagiosadmin@sboxdc.com" -s "** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **" --set email-smtp.eu-west-1.amazonaws.com:587 <email-address>



#Save and exit the file .

Add your email id in contact.cfg as below.



#vi /usr/local/nagios/etc/objects/contacts.cfg

define contact {

contact_name  nagiosadmin ; Short name of user
use generic-contact ; Inherit default values from generic-contact template (defined above)
alias Nagios Admin ; Full name of user
email <email-address> ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******
}



#Save and exit from the file.



#Restart Nagios server.

systemctl restart nagios.service

