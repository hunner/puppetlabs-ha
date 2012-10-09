class ha::util::drbd (
  $cluster    = $ha::cluster,
  $disk       = $ha::disk,
  $mountpoint = $ha::mountpoint,
  $primary    = $ha::primary,
  $format     = $ha::format,
  $resource   = $ha::resource,
  $device     = $ha::device,
  $owner      = $ha::owner,
  $group      = $ha::group,
) inherits ha {
  if $is_virtual == 'true' and $osfamily == 'Debian' {
    # For DRBD kernel module
    if ! defined(Package["linux-image-extra-${::kernelrelease}"]) {
      package { "linux-image-extra-${::kernelrelease}":
        ensure => present,
        before => [
          Class['::drbd'],
          Drbd::Resource[$resource],
        ],
      }
    }
  }

  # DRBD configuration
  anchor { 'ha::util::drbd::begin': }
  -> class { '::drbd': }
  -> anchor { 'ha::util::drbd::end': }

  ::drbd::resource { $resource:
    cluster       => $cluster,
    disk          => $disk,
    ha_primary    => $primary,
    initial_setup => $format,
    mountpoint    => $mountpoint,
    owner         => $owner,
    group         => $group,
    device        => $device,
  }

  # Corosync primitives

  cs_primitive { "${resource}_data":
    ensure          => present,
    primitive_class => 'ocf',
    provided_by     => 'linbit',
    primitive_type  => 'drbd',
    cib             => $resource,
    parameters      => { 'drbd_resource' => $resource, },
    operations      => {
      'monitor' => {
        'interval' => '60s',
      },
      'start' => {
        'interval' => '0',
        'timeout'  => '240s',
      },
      'stop' => {
        'interval' => '0',
        'timeout'  => '100s',
      },
    },
    ms_metadata     => {
      'master-max'      => '1',
      'master-node-max' => '1',
      'clone-max'       => '2',
      'clone-node-max'  => '1',
      'notify'          => true,
    },
    promotable      => true,
    require         => Package['drbd'],
  }
  cs_primitive { "${resource}_fs":
    ensure          => present,
    primitive_class => 'ocf',
    provided_by     => 'heartbeat',
    primitive_type  => 'Filesystem',
    cib             => $resource,
    parameters      => {
      'device'    => $device,
      'directory' => $mountpoint,
      'fstype'    => 'ext4',
    },
    operations      => {
      'start' => {
        'interval' => '0',
        'timeout'  => '60s',
      },
      'stop' => {
        'interval' => '0',
        'timeout'  => '60s',
      },
    },
    require         => [
      Package['drbd'],
      Cs_primitive["${resource}_data"],
    ],
  }
  cs_order { "${resource}_fs-after-${resource}_data":
    ensure => present,
    first  => "ms_${resource}_data:promote",
    second => "${resource}_fs:start",
    score  => 'INFINITY',
    cib    => $resource,
  }
  cs_colocation { "${resource}_fs-on-data":
    ensure     => present,
    primitives => ["ms_${resource}_data:Master", "${resource}_fs"],
    score      => 'INFINITY',
    cib        => $resource,
  }
}
