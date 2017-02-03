# devstack Installation

This ansible playbook installs a functional DevStack setup. The required Vagrantfile are also provided.
```
$ vagrant up
```
or if you have a machine already running then,
```
$ ansible-playbook -i inventory play.yml
```

## Note
* Tested with - 
..* ansible 2.2.0.0
..* Ubuntu Trusty x86-64
..* Ubuntu Xenial x86-64

