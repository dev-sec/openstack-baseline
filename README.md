# InSpec Compliance for the OpenStack Security Guide

This is a collection of [InSpec](http://inspec.io) scripts to check compliance against the [OpenStack Security Guide](http://docs.openstack.org/security-guide/).

The control checklists for Keystone, Horizon, Cinder, Nova and Neutron are implemented based on OpenStack Mitaka and beyond configuration standards.

Some control implementation exists for Swift and Manila, but has not been tested.

Beta-level controls exist for Glance. These controls are inspired by those currently recommended in the OpenStack Security Guide for Cinder.

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

## Run tests against remote host(s)

Note that the controls can only be run against a single host until
https://github.com/chef/inspec/issues/268 is closed.

If your OpenStack control plane consists of multiple hosts, you'll need to
run InSpec against each host separately.

```shell
bundle exec inspec exec . -t ssh://user@hostname
```

## Run controls for a particular service

### Identity controls

```shell
bundle exec inspec exec . \
  --controls check-identity-01 check-identity-02 \
    check-identity-03 check-identity-04 \
    check-identity-05 check-identity-06
```

### Dashboard controls

```shell
bundle exec inspec exec . \
  --controls check-dashboard-01 check-dashboard-02 \
    check-dashboard-03 check-dashboard-04 \
    check-dashboard-05 check-dashboard-06 \
    check-dashboard-07 check-dashboard-08 \
    check-dashboard-09 check-dashboard-10 \
    check-dashboard-11
```

### Block Storage controls

```shell
bundle exec inspec exec . \
  --controls check-block-01 check-block-02 \
    check-block-03 check-block-04 \
    check-block-05 check-block-06 \
    check-block-07 check-block-08
```

### Compute controls

```shell
bundle exec inspec exec . \
  --controls check-compute-01 check-compute-02 \
    check-compute-03 check-compute-04 \
    check-compute-05
```

### Network controls

```shell
bundle exec inspec exec . \
  --controls check-neutron-01 check-neutron-02 \
    check-neutron-03 check-neutron-04 \
    check-neutron-05
```

### Image controls

```shell
bundle exec inspec exec . \
  --controls check-image-01 check-image-02 \
    check-image-03 check-image-04
```

### Orchestration controls
```shell
bundle exec inspec exec . \
  --controls check-orchestration-01 check-orchestration-02 \
    check-orchestration-03 --attrs attributes.yml
```

attributes.yml has the following contents
```yaml
heat_enabled: true
```

### Telemetry and Telemetry Alarming controls

```shell
inspec exec . --controls check-telemetry-01 check-telemetry-02 \
                check-telemetry-03 check-telemetry-04 \
                check-telemetry-alarming-01 check-telemetry-alarming-02 \
                check-telemetry-alarming-03 \
                --attrs attributes.yml
```

attributes.yml has the following contents
```yaml
ceilometer_enabled: true
aodh_enabled: true
```

# License

Apache 2

## License & Authors

- Author: JJ Asghar ([jj@chef.io](mailto:jj@chef.io))

```text
Copyright:: 2015-2017, Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
