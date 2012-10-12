class ha::haproxy (
  $ports,
  $ipaddress = $ha::vip,
  $options   = undef,
  $resource  = $ha::resource,
) inherits ha {
  class { '::haproxy':
    manage_service => false,
  }
  ::haproxy::listen { $resource:
    ipaddress => $vip,
    ports     => $ports,
    options   => $options,
  }
  class { 'ha::util::corosync':
    require => Class['::haproxy'],
  }
  class { 'ha::util::vip': }
  cs_primitive { "${resource}_haproxy":
    primitive_class => 'lsb',
    primitive_type  => 'haproxy',
    cib             => $resource,
    operations      => {
      monitor => {
        'interval' => '20s',
      },
    },
  }
  cs_colocation { "${resource}_haproxy-on-ip":
    ensure     => present,
    primitives => ["${resource}_ip", "${resource}_haproxy"],
    cib        => $resource,
    score  => 'INFINITY',
  }
  cs_order { "${resource}_haproxy-after-${resource}_ip":
    ensure  => present,
    first   => "${resource}_ip",
    second  => "${resource}_haproxy",
    score   => 'INFINITY',
    cib     => $resource,
    require => Cs_colocation["${resource}_haproxy-on-ip"],
  }
  include corosync::reprobe
}
