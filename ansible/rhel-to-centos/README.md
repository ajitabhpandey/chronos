# rh6xtocentos6x Migration

This ansible playbook migrates a Red Hat Enterprise Linux 6.x install to an equivallent CentOS 6.x install.

## Example playbook runs

* Simple inventory based run. Assumes everything is properly configured in play.yml
```
$ ansible-playbook -i inventory play.yml
```

* Specified the host, user using which the connections will be made and private key file on the command line

```
$ ansible-playbook -vvv -i '10.39.201.80,' -e "ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/id_rsa" play.yml
```

## Note
* Tested with -
	* ansible >= 2.2.0.0
	* RHEL 6.8 to CentOS 6.8
 	* RHEL 6.9 to CentOS 6.9
