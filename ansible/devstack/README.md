# devstack Installation

This ansible playbook installs a functional DevStack setup. The required Vagrantfile are also provided.
```
$ vagrant up
```
or if you have a machine already running then,
```
$ ansible-playbook -i inventory play.yml
```
