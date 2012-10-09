class ha::util::vip (
  $resource = $ha::resource,
  $vip      = $ha::vip_real,
) inherits ha {
  cs_primitive { "${resource}_ip":
    primitive_class => 'ocf',
    provided_by     => 'heartbeat',
    primitive_type  => 'IPaddr2',
    cib             => $resource,
    parameters      => {
      ip           => $vip,
      cidr_netmask => '32',
    },
  }
}
