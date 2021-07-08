# resolv_conf

[![Build Status](https://github.com/smoeding/puppet-resolv_conf/actions/workflows/CI.yaml/badge.svg)](https://github.com/smoeding/puppet-resolv_conf/actions/workflows/CI.yaml)
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

  * Up to 3 name servers may be listed.
  * Up to 6 items may be included in the search list.
  * Up to 10 items may be included in the sortlist.
  * The domain and search keywords are mutually exclusive.

## Setup

### What resolv_conf affects

The module creates and manages the content of the `/etc/resolv.conf` file. This affects the way the host is able to map hostname to IP addresses and vice versa.

### Setup Requirements

The module uses the Puppet `stdlib` module.

### Beginning with resolv_conf

Declare the class to create a configuration that uses only a local name server on `127.0.0.1`.

```puppet
class { 'resolv_conf': }
```

## Usage

You can use class parameters to use a customized configuration.

```puppet
class { 'resolv_conf':
  nameservers => [ '9.9.9.9', ],
}
```

You can also use Hiera to create this configuration.

```
resolv_conf::nameservers:
  - '9.9.9.9'
```

### Specify a remote name server and use local domain for unqualified hostnames

The following configuration will configure a remote name server and use the name of the local domain when unqualified hostnames are queried.

```puppet
class { 'resolv_conf':
  nameservers => [ '9.9.9.9', ],
  domain      => $::domain,
}
```

If your host is based in the `example.net` domain, then a lookup for the hostname `server` will query the name server for `server.example.net`.

### Specify name servers & options

This setup creates a configuration file with the given name servers and will also set additional opions to enable name server rotation and set a specific timeout.

```puppet
class { 'resolv_conf':
  nameservers => [ '8.8.8.8', '8.8.4.4', ],
  options     => [ 'rotate', 'timeout:2', ],
}
```

### Prefer a local name server

The following setup will create a configuration where the name server at `127.0.0.1 ` is queried first and only then the additional name servers are used.

```puppet
class { 'resolv_conf':
  nameservers              => [ '8.8.8.8', '8.8.4.4', ],
  prepend_local_nameserver => true,
}
```

**Note**: This module does not configure a local name server that will answer queries on `127.0.0.1`. You will have to use a different Puppet module to manage the name server.

## Reference

See [REFERENCE.md](https://github.com/smoeding/puppet-resolv_conf/blob/master/REFERENCE.md)

## Development

You may open Github issues for this module if you need additional options currently not available.

Feel free to send pull requests for new features.
