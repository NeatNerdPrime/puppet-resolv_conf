# resolv_conf

[![Build Status](https://travis-ci.org/smoeding/puppet-resolv_conf.svg?branch=master)](https://travis-ci.org/smoeding/puppet-resolv_conf)
[![Puppet Forge](http://img.shields.io/puppetforge/v/stm/resolv_conf.svg)](https://forge.puppetlabs.com/stm/resolv_conf)
[![License](https://img.shields.io/github/license/smoeding/puppet-resolv_conf.svg)](https://raw.githubusercontent.com/smoeding/puppet-resolv_conf/master/LICENSE)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with resolv_conf](#setup)
	* [What resolv_conf affects](#what-resolv_conf-affects)
	* [Setup requirements](#setup-requirements)
	* [Beginning with resolv_conf](#beginning-with-resolv_conf)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Development - Guide for contributing to the module](#development)

## Overview

Manage the `/etc/resolv.conf` on Linux and FreeBSD.

## Module Description

The module manages the DNS resolver configuration file. It allows setting the values for the `nameserver`, `domain`, `search`, `sortlist` and `options` confguration settings. The following restrictions are enforced by the module:

  * Up to 3 nameservers may be listed.
  * Up to 6 items may be included in the search list.
  * Up to 10 items may be included in the sortlist.
  * The domain and search keywords are mutually exclusive.

## Setup

### What resolv_conf affects

The module creates and manages the content of the `/etc/resolv.conf` file. This affects the way the host is able to map hostname to IP addresses and vice versa.

### Setup Requirements

The module uses the Puppet `stdlib` module.

### Beginning with resolv_conf

Declare the class to create a configuration that uses only a local nameserver on `127.0.0.1`.

```puppet
class { 'resolv_conf': }
```

## Usage

You can use class parameters to use a customized configuration.

```puppet
class { 'resolv_conf':
  nameserves => [ '9.9.9.9', ],
}
```

You can also use Hiera to create this configuration.

```
resolv_conf::nameservers:
  - 9.9.9.9
```

### Create resolver config file with specific nameservers & options

This setup creates a configuration file with the given nameservers and will also set additional opions to enable nameserver rotation and set a specific timeout.

```puppet
class { resolv_conf':
  nameservers => [ '8.8.8.8', '8.8.4.4', ],
  options     => [ 'rotate', 'timeout:2, ],
}
```

### Create resolver config file where a local nameserver is prefered

The following setup will create a configuration where the nameserver at `127.0.0.1 ` is queried first and only then the additional nameservers are used.

```puppet
class { resolv_conf':
  nameservers              => [ '8.8.8.8', '8.8.4.4', ],
  prepend_local_nameserver => true,
}
```

## Reference

### Public Classes

#### Class: `resolv_conf`

Performs the basic setup and creates the `resolv.conf` file.

**Parameters for the `resolv_conf` class:**

##### `nameservers`

An array of nameservers that the resolver should query for hostname lookups. A maximum number of three nameservers can be specified. The default value is a single element array containing `127.0.0.1`.

##### `domainname`

A string that is the primary domain of the host. Unqualified lookups will append this string to the query host. This parameter cannot be used together with `searchlist`.

##### `searchlist`

An array of domains that the resolver will search. A maximum of 6 domains can be specified. This parameter cannot be used together with `domainname`.

##### `sortlist`

An array of up to 10 IP/netmask items. These are used by the resolver to sort the result in case multiple addresses are returned.

##### `options`

An array of option settings for the resolver. Each array element must be the option to include in the configuration. The following options are recognized: `ndots:n`, `timeout:n`, `attempts:n`, `debug`, `edns0`, `inet6`, `ip6-bytestring`, `ip6-dotint`, `no-ip6-dotint`, `no-check-names`, `rotate`, `single-request`, `single-request-reopen`. The first three options are expected to use a numeric value for `n` after the colon. Check the man page `resolv.conf(5)` for details.

##### `prepend_local_nameserver`

A boolean value that determines if a local DNS server should be used first. Setting this parameter to `true` will add `127.0.0.1` before the servers given as `nameservers`. The last nameserver is silently ignored if this would create a configuration with more than three servers. The default value is `false`.

##### `resolv_conf_file`

The absolute path of the file to manage. The default is `/etc/resolv.conf`. In general it does not make sense to change this parameter.

##### `owner`

The owner of the file `/etc/resolv.conf`. The default is `root`.

##### `group`

The group of the file `/etc/resolv.conf`. The default is `root` on Linux and `wheel` on FreeBSD.

##### `mode`

The file mode of the file `/etc/resolv.conf`. The default is `0644`.

## Development

You may open Github issues for this module if you need additional options currently not available.

Feel free to send pull requests for new features.