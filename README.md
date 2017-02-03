# InSpec Compliance for the OpenStack Security Guide

This is a collection of [InSpec](http://inspec.io) scripts to check compliance against the [OpenStack Security Guide](http://docs.openstack.org/security-guide/).

The control checklists for Keystone, Horizon, Cinder, Nova and Neutron are implemented based on OpenStack Mitaka and beyond configuration standards.

Some control implementation exists for Swift and Manila, but has not been tested.

## Installation

```shell
git clone git@github.com:chef-partners/inspec-openstack-security.git
cd inspec-openstack-security
bundle install
```

## Run tests locally

```shell
bundle exec inspec exec .
```

## Run tests against remote host

```shell
bundle exec inspec exec . -t ssh://user@hostname
```

## Run only the identity controls

```shell
bundle exec inspec exec . \
  --controls check-identity-01 check-identity-02 \
    check-identity-03 check-identity-04 \
    check-identity-05 check-identity-06
```

# To Do

https://github.com/chef-partners/inspec-openstack-security/issues

# License

Apache 2

