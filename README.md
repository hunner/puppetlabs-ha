# HA module for Puppet

## Description
Provides out-of-the-box clustering/HA solutions for various software products via DRBD, Corosync, HAProxy, and perhaps others. The clusters should be both explicitly configurable, or allow auto-discovery via exported resources.

## Usage

Examples and descriptions of the various usable classes follow. Obvious the examples are simple, and the classes allow for greater control, but this gets you started.

Each of the `ha::*` subclasses are meant to be independent on a per-node basis, not combined.

### ha

The base class is a configuration interface for the underlying software. It does nothing without also including `ha::*` subclasses.

It is meant to either be directly configured, or coupled with hiera, puppetdb search functions, or ENCs. See following sections for examples.

### ha::vip

This class provides Virtual IP failover between the cluster nodes via Corosync. Example:

```puppet
class { 'ha':
  cluster => 'cluster-2',
  vip     => '23.23.23.23',
  members => [
    '10.0.0.3',
    '10.0.0.2',
  ],
}

class { 'ha::vip': }
```

### ha::drbd

This class provides DRBD disk replication. Failover is done via Corosync. Example:

```puppet
class { 'ha':
  cluster => 'cluster-3',
  disk    => '/dev/vdb',
  vip     => '23.23.23.23',
  members => [
    '10.0.0.3',
    '10.0.0.2',
  ],
}

class { 'ha::drbd':
  mountpoint => '/drbd/mount',
}
```

### ha::mysql

This class provides MySQL replication via DRBD and failover via Corosync. Example:

```puppet
class { 'ha':
  cluster => 'cluster-4',
  disk    => '/dev/mock_disk',
  vip     => '23.23.23.23',
  members => [
    '10.0.0.3',
    '10.0.0.2',
  ],
}

class { 'ha::mysql':
  datadir => '/var/lib/mysql',
}
```

### ha::haproxy

This class provides HAProxy failover via Corosync. Example:

```puppet
class { 'ha':
  cluster => 'cluster-5',
  vip     => '23.23.23.23',
  members => [
    '10.0.0.3',
    '10.0.0.2',
  ],
}

class { 'ha::haproxy':
  ipaddress => '23.23.23.23',
  ports     => '80,443',
}
```
