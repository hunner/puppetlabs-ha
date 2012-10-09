define ha::mysql::corosync::second {
  $resource = $name
  # This is a define and a sub-define because of a fricking hack in puppet that
  # runs defines  and exported resource collections in alternating patterns. The
  # resource that we're searching for is two defineds deep in the DRBD module,
  # so we also need two defines.
  if defined(Drbd::Resource::Up[$resource]) {
    class { '::mysql::server':
      manage_service => false,
      config_hash    => {
        'bind_address' => $vip,
        'restart'      => false,
      },
      before => [
        Class['ha::util::corosync'],
        Class['ha::util::vip'],
        Cs_primitive["${resource}_mysqld"],
      ],
      require => [
        Drbd::Resource::Up[$resource],
        Drbd::Resource[$resource],
      ],
    }
    class { 'ha::util::corosync':
      require => [
        Drbd::Resource::Up[$resource],
        Drbd::Resource[$resource],
        Class['::mysql::server'],
      ],
    }
    cs_primitive { "${resource}_mysqld":
      ensure          => present,
      primitive_class => 'lsb',
      primitive_type  => 'mysql',
      cib             => $resource,
      operations      => {
        start => {
          interval => "0",
          timeout  => "120",
        },
        stop => {
          interval => "0",
          timeout  => "120",
        },
        monitor => {
          interval => "20",
        },
      },
    }
    cs_colocation { "${resource}_mysqld-on-fs":
      ensure     => present,
      primitives => ["${resource}_fs", "${resource}_mysqld"],
      score      => 'INFINITY',
      cib        => $resource,
    }
    cs_order { "${resource}_mysqld-after-${resource}_fs":
      ensure  => present,
      first   => "${resource}_fs",
      second  => "${resource}_mysqld",
      score   => 'INFINITY',
      require => Cs_colocation["${resource}_mysqld-on-fs"],
      cib     => $resource,
    }
    if $vip {
      cs_colocation { "${resource}_ip-on-data":
        ensure     => present,
        primitives => ["ms_${resource}_data:Master", "${resource}_ip"],
        score      => 'INFINITY',
        cib        => $resource,
      }
      cs_colocation { "${resource}_mysqld-on-ip":
        ensure     => present,
        primitives => ["${resource}_ip", "${resource}_mysqld"],
        score      => 'INFINITY',
        cib        => $resource,
      }
      cs_order { "${resource}_mysqld-after-${resource}_ip":
        ensure  => present,
        first   => "${resource}_ip",
        second  => "${resource}_mysqld",
        score   => 'INFINITY',
        require => Cs_colocation["${resource}_mysqld-on-ip"],
        cib     => $resource,
      }
    }
    include corosync::reprobe
  }
}
