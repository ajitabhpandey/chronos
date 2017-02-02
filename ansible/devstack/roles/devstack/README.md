# devstack

This role installs the [DevStack](http://docs.openstack.org/developer/devstack/). DevStack is a series of extensible scripts used to quickly bring up a complete OpenStack environment based on the latest versions of everything from git master. It is used interactively as a development environment and as the basis for much of the OpenStack project’s functional testing.

## Requirements

None

## Role Variables

* STACK_USER - Defines the user using which devstack will be installed
* STACK_GROUP - The primary group of STACK_USER
* STACK_HOME - The home directory of STACK_USER. This is where the git repository should reside.
* DEVSTACK_GIT_URL - URL of the DevStack git repository which needs to be cloned.
* DEVSTACK_GIT_CLONE_LOCATION - The devstack git repository will be cloned in this directory
* DEVSTACK_ADMIN_PASSWORD: This is the default admin password for DevStack installation
* PIP_URL - This is the location from where python pip is downloaded. Changing this is not recommended. This has to be included as a part of playbook because while the stack.sh was running, I found that the curl command included there was failing due to SSL certfication validation check failure. Normally I could have included a `-k` switch in curl to ignore the certificate, but it would not be consistent after every git clone. Upon checking the script I found that if a local downloaded get_pip.py is found at a location, the new download will not be performed. So I made this download a part of ansible playbook.

## Dependencies

None

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- hosts: all
  roles:
    - devstack
```
## License

BSD

## Author Information

Ajitabh Pandey [[ ajitabhpandey (at) ajitabhpandey.info]]
http://ajitabhpandey.info
