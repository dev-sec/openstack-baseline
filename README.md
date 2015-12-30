# InSpec Security Guide

This is a collection of [InSpec]() scripts to help check against the [OpenStack Security Guide](http://docs.openstack.org/security-guide/).


To run these tests you can use:

```bash
git clone git@github.com:chef-partners/inspec-openstack-security.git

# run test locally
inspec exec inspec-openstack-security

# run test on remote host on SSH
inspec exec inspec-openstack-security -t ssh://user@hostname
```
