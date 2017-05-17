#Oracle-XE
An ansible role for installing Oracle XE
##Requirements
This roles requires that you download the Oracle XE RPM file from OTN and place it in the files directory. I downloaded 

	oracle-xe-11.2.0-1.0.x86_64.rpm
##Role Variables
- **oracle_http_port** - Default value 8080 and is the variable which defines the port on which PL/SQL Gateway runs
- **oracle_listener_port** - Default value 1521. This is port on which the Oracle listener service runs
- **oracle_system_pwd** - Default password used for sys and Apex admin
- **oracle_start_boot** - Default value is "y". Used for controlling whether Oracle XE has to be started on boot or not.
- **oracle_reconfigure** - Default value is "n". Used for deciding if an existing XE install has to be reconfigured for various parameters.
- **copy_rpm** - Default value is "n". This variable is used to determine if the playbook will be copying Oracle XE RPM to the destination location or not. If this is the first time the playbook is being run, change this value to "y" so that XE RPM can be copied.
- **swapfile_size** - Default value is 2048. If a swap file of a suitable size is not found then one will be created of 2048 MB
- **swapfile_location** - Default value is /swapfile. This is the full path along with swapfile name which will be created if it does not exists.
- **ORACLE_BASE** - Default value is /u01/app/oracle

##Dependencies
None

##Example Playbook
Following are some examples of how to use this role:

##License
BSD

##Author Information
Ajitabh Pandey [[ajitabhpandey (at) ajitabhpandey (dot) info]]