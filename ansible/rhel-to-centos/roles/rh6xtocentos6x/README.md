# rh6xtocentos6x

This role migrates from RHEL 6.x to CentOS 6.x. Since this method is neither endorsed by RedHat and nor by CentOS, I can not recommend this method for migrating a production system on the fly. I have found this method to be working, but it may very well break your existing production system, so test it thoroughly before trying this in production.

Most of the places I have used command module. This was required as either certain commands did not have equivalent options (e.g subscription-manager clean command does not have any suitable option in the redhat_subscription module) or they need to be forced executed and there was no suitable option in the yum module (e.g. rpm -Uvh and rpm -e --no-deps).

## Requirements

I have migrated many RedHat systems to CentOS with this playbook. Last I tried was RHEL 6.8 to CentOS 6.8, so please download the following packages from http://mirror.centos.org/centos/6/os/x86_64/Packages/. In case you have a higher version migrations taking place, please use the package versions from that version in CentOS.

* centos-release-6-8.el6.centos.12.3.x86_64.rpm
* centos-indexhtml-6-2.el6.centos.noarch.rpm
* yum-3.2.29-73.el6.centos.noarch.rpm
* yum-plugin-fastestmirror-1.1.30-37.el6.noarch.rpm
* python-urlgrabber-3.9.1-11.el6.noarch.rpm

## Role Variables

* CENTOS_RPM_STORE: This variable holds fully qualified path and name of the temporary directory where the initial required CentOS RPM files will be copied.

## Dependencies

None

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- hosts: all
  become: true
  become_user: root
  roles:
    - rh6xtocentos6x
```
## License

BSD

## Author Information

Ajitabh Pandey [[ ajitabhpandey (at) ajitabhpandey.info]]
http://ajitabhpandey.info
