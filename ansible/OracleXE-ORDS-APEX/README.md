#README
This playbook installs the following on the specified inventory - 

* Oracle XE
* ORDS
* APEX
* Tomcat
* JDK
* Apache

Due to licence restrictions, Oracle XE, ORDS and APEX have to be downloaded manually and placed in the "files" directory in respective roles. Tomcat is downloaded directly from one of the mirrors. Before kicking off the installation, it is advisable that you check the tomcat version from the mirror and update the correct mirror URL value in the variables.

## Roles
The playbook has been organized as roles. Each role may have several variables, templates, files and tasks. Following sections will help explain these vaious roles - 

### APACHE
This role installs Apache web server.  Although, tomcat directly can be used to serve Apex applications, the set up which I have done uses Apache to work as an AJP proxy to serve the applications. This is a very simple role and at present does not need any special handling. The functionality of this role can easyly be merged into one of the pre-tasks of the playbook.

### JDK
This role installs the Oracle Java SE Development Kit. JDK can be downloaded from [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](OTN). After downloading the RPM, place it in the files directory under the JDK role. 

The tasks - 

* Checks if JDK is installed
* Copies the JDK RPM file to the server if JDK is not installed
* Installs the JDK RPM if JDK is not installed
* Copies the profile template file with environment server
* Removes the copied RPM file.

Following variables are used in this role - 

* `JDK_INSTALLATION_RPM`: This is the RPM file name as downloaded from Oracle website. When I wrote this playbook, I used jdk-8u121-linux-x64.rpm.
* `JDK_VERSION_TO_INSTALL`: This variable controls the JDK version to be installed. At the time of writing this playbook, I used jdk1.8.0_121 as the value. The reason this variable is required is because, though the RPM file is named in a particular format, the rpm -qa displays the JDK version in the format specified by this variable.
* `JAVA_HOME`: This is where the JDK is installed. The current value is /usr/java/latest and it is ***not recommended*** to be changed. 

### Tomcat

This role installs tomcat directly after downloading it from one of its mirrors. It takes care of deploying an appropriate startup script based on the target system.

Following variables are used in this role. None of these may need a change except TOMCAT_PORT, TOMCAT_VERSION_TO_INSTALL and TOMCAT_DOWNLOAD_LINK - 

* `TOMCAT_PORT`: This defines the tomcat connector port. It is set to 8090 in the defaults/main.yml file. This is because port 8080 which is the default port is in use elsewhere by the oracle echosystem.
* `TOMCAT_VERSION_TO_INSTALL`: apache-tomcat-8.5.15
* `TOMCAT_DOWNLOAD_LINK`: This the URL from which tomcat will be downloaded and installed.
* `TOMCAT_INSTALL_LOCATION`: The directory where tomcat is to be installed. Currently set to /usr/share/tomcat
* `TOMCAT_USER`: The user using which tomcat runs as. Currently set to tomcat
* `TOMCAT_GROUP`: The group of tomcat. Currently set to tomcat.
* `CATALINA_HOME`: The symlink to the tomcat install location currently being used. There can be more than one tomcat installations present. Currently set to "{{ TOMCAT_INSTALL_LOCATION }}/latest" and points to /usr/share/tomcat/apache-tomcat-8.5.15
* `CATALINA_OPTS`: The options to be passed to tomcat during startup. Currently set to -Xms512M -Xmx1024M -server -XX:+UseParallelGC
* `JAVA_HOME`: The JDK install location on the box. Currently set to /usr/java/latest
* `JRE_HOME`: The JRE location on the box. Currently set to "{{ JAVA_HOME}}/jre"
* `JAVA_OPTS`: Options for the Java virtual machine. Currently set to -Djava.awt.headless=true -Djava.security.egd=file:dev/./urandom

### ORACLE-XE
This role installs the Oracle Database eXpress Edition. The RPM for Oracle-XE can be downloaded from [http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html](OTN). After downloading this RPM, place it in the files directory under the oracle-xe roles. 

The installation of the role goes as follows - 

* Dependencies are installed.
* Required users and groups are added.
* Required directory paths are created and appropriae ownership assigned.
* Swap file is created only if this does not already exists.
* Oracle XE RPM is copied to the server if either the oracle init script does not already exists (meaning oracle is not installed) or the copy_rpm variable is set to yes.
* Oracle XE RPM is installed if it is not already installed.
* Oracle XE is configured if either it is not already configured or the reconfiguration is desired via the value of oracle_reconfigure variable.
* Oracle environment variables file is copied to the system bash_profile if it is not already present.
* A script to set the system password is executed which sets the password as per the value specified in oracle_system_pwd variable.
* Copied scripts are cleaned up. 

The variables being used are - 

* `oracle_http_port`: This is the Oracle HTTP port. Currently set to 8080.
* `oracle_listener_port`: This is the port on which Oracle listener listens for incoming connections. Currently this is set to 1521. 
* `oracle_system_pwd`: This is the default Oracle System User Password. This password will also be used for the default admin user for the Apex install. Currently this is set to Passw0rd, you should change it either in the role configuration file or immediately after the install.
* `oracle_start_boot`: The variables decides if Oracle XE will be started on boot. Currently this is set to y. 
* `oracle_reconfigure`: The value of this variable determins if the Oracle XE needs to be reconfigured only. If this is changed to yes then all the reconfiguration options for XE will be run. If set to no and oracle is already installed/configured, nothing is changed. Currently this is set to no. This should be left as it is in most of the cases. 
* `copy_rpm`: The value of this variable determins if the Oracle RPM will be copied to the destination server or not. Currently this is set to no. If installing for the first time, you should change this to yes either in the defaults/main.yml file or using the extended arguments on the commandline as shown in one of the examples below.
* `swapfile_size`: Oracle needs a swapfile. This variable specifies the size of the swapfile. Currently set to 2048
* `swapfile_location`: This variable specifies the location of the swapfile. Currently set to /swapfile
* `ORACLE_BASE`: This is the Oracle Base install location. Currently set to /u01/app/oracle.

### ORDS
This role performs ORDS manual install and takes help of EXPECT utility in the installation. ORDS (Oracle REST Data Services) can be downloaded from [http://www.oracle.com/technetwork/developer-tools/rest-data-services/downloads/index.html](OTN). After downloading this file, place the file under the files directory in the ORDS role.

The installation goes as follows - 

* Dependencies installed.
* Requird directories are created and permissions assigned.
* ORDS archive file is unzipped on the destination location.
* A seperate temp directory is created to unarchive the ORDS zip file for the manual install as some SQL files needs to be accessed. This is later deleted as a part of cleanup.
* Copies the reuired scripts and response files for the manual install.
* Performs the manual install.
* Performs the cleanup by deleting all the scripts / directories etc.
* Copies the ORDS WAR file to the tomcat webapp location.

Variables are - 

Some tablespaces used by ORDS installation -

* `TBSPC_ORDS_METADATA`: Tablespace used for installing ORDS Metadata. Currently set to SYSAUX.
* `TMP_TBSPC_ORDS_METADATA`: Temporary tablespace used for ORDS Metadaa. Currently set to TEMP.
* `TBSPC_ORDS_PUBLIC_USER`: Tablespace used for ORDS_PUBLIC_USER schema. Currently set to USERS.
* `TMP_TBSPC_ORDS_PUBLIC_USER`: Temporary tablespace used for ORDS_PUBLIC_USER schema. Currently set to TEMP.

Database connectivity details - 

* `DB_HOST`: Database host to connect to. Currently set to localhost.
* `DB_PORT`: Database port to connect to. Currently set to 1521.
* `DB_SID`: Database SID. Currently set to xe.
* `DB_USER`: APEX public user. Currently set to APEX_PUBLIC_USER.
* `HTTP_PORT`: 8080
* `STATIC_IMAGES`: /i/

Following are some of the passwords for various schemas used by APEX and ORDS -
 
* `ORDS_PUBLIC_USER_PASSWORD`: Passw0rd
* `APEX_LISTENER_PASSWORD`: Passw0rd
* `APEX_PUBLIC_USER_PASSWORD`: Passw0rd
* `APEX_REST_PUBLIC_USER_PASSWORD`: Passw0rd
* `XE_SYS_PASSWORD`: Passw0rd

Some other variables - mostly self explanatory - 

* `ORDS_ARCHIVE`: ords.3.0.9.348.07.16.zip
* `BASE_LOCATION`: /u01
* `ORDS_DEST_LOCATION`: "{{ BASE_LOCATION }}/ords"
* `ORDS_CONFIG_LOCATION`: "{{ ORDS_DEST_LOCATION }}/config"
* `ORDS_USER`: oracle
* `ORDS_GROUP`: oinstall
* `ORDS_MANUAL_EXTRACT_LOCATION`: /tmp/ords
* `ORDS_MANUAL_INSTALL_RESP`: ords_manual_install.resp
* `ORDS_MANUAL_INSTALL_SH`: ords_manual_install.sh
* `ORDS_CONFIG_SH`: ords_config.exp
* `TOMCAT_USER`: tomcat
* `TOMCAT_GROUP`: tomcat
* `TOMCAT_WEBAPP_LOCATION`: /usr/share/tomcat/latest/webapps

### APEX Upgrade
Oracle-XE already comes with APEX version 4.x. After the installation of XE, APEX can be upgraded to the latest APEX 5.1. This role performs this upgrade. APEX can be downloaded from [http://www.oracle.com/technetwork/developer-tools/apex/downloads/download-085147.html](OTN). After downloading place the zip file in the files directory under the apex-upgrade role. In case there is a newer version available then you can use that also and the installation steps should remain the same, as the installation is taken care of by the install sql script which came with the APEX.

Following are the variables used - 

* `APEX_ARCHIVE`: apex_5.1.zip
* `APEX_DEST_LOCATION`: This is where the APEX zip will be unarchived. Currently set to /u01/downloads.
* `ORACLE_USER`: oracle
* `ORACLE_GROUP`: dba
* `APEX_SCRIPT_LOCATION`: "{{ APEX_DEST_LOCATION }}/apex"

Custom configuration scripts - 

* `APEX_INSTALL_SCRIPT`: apexins.sh
* `APEX_POST_INSTALL_SCRIPT`: apex_post_install.sh
* `APEX_ORDS_REST_SCRIPT`: apex_rest_config.sh
* `APEX_ORDS_REST_CONFIG`: apex-rest-config-input

Passwords for some of the users used by APEX and ORDS

* `APEX_PUBLIC_USER_PASSWORD`: Passw0rd123
* `APEX_LISTENER_PASSWORD`: Passw0rd123
* `APEX_REST_PUBLIC_USER_PASSWORD`: Passw0rd123

* `WEBAPPS_ROOT`: Tomcat webapps location. Currently set to /usr/share/tomcat/latest/webapps.
* `APACHE_FRONT`: The value of this variable tells if the setup uses Apache webserver in front of tomcat. The default value is yes. It has been specifed as "!!str yes". The reason for the same can be read here - [https://ajitabhpandey.info/2017/03/ansible-quirks-1/](Ansible Quirks - 1)
* `APACHE_WEB_DIR`: This is where usually Apache web root is present if apache is installed. Currently set to /var/www.
* `APACHE_IMAGES_LOCATION`: This is the directory in apache web root location where apex images will be copied. This is set to "{{ APACHE_WEB_DIR }}/apex".
* `TOMCAT_USER`: Tomcat user. Set to tomcat
* `TOMCAT_GROUP`: Tomcat group. Set to tomcat

##Examples
###Running this playbook
**Executing playbook for a single hostgroup**

	$ ansible-playbook -l db-servers playbooks/play.yml

**Executing playbook for tasks with tag**

	$ ansible-playbook -l db-servers playbooks/play.yml --tags "install,xe,java,tomcat,ords,apex-upgrade" --skip-tags "skip-this"
It is not necessary for the playbook task to have all these tags in order for it to be executed. Any one of these tags will trigger the execution

**Executing playbook with commandline overrides of some variables**

	$ ansible-playbook -vvv -i '35.154.158.42,' -e "ansible_ssh_user=centos copy_rpm=no ansible_ssh_private_key_file=~/.ssh/db_server_id_rsa" playbooks/play.yml
