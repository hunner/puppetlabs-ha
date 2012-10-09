class ha (
  $cluster         = hiera('ha_cluster', $::ha_cluster),
  $disk            = hiera('ha_disk', $::ha_disk),
  $members         = hiera_array('ha_members', [$::ipaddress]),
  $primary         = hiera('ha_primary',$::ha_primary),
  $vip             = undef,
  $device          = $ha::params::device,
  $format          = $ha::params::format,
  $check_standby   = $ha::params::check_standby,
  $resource        = $ha::params::resource,
  $ca_cert         = $ha::params::ca_cert,
  $stonith_enabled = $ha::params::stonith_enabled,
  $stickiness      = $ha::params::stickiness
) inherits ha::params {
  $vip_real = $::ha_vip ? {
    undef   => hiera('ha_vip', $vip),
    default => $::ha_vip,
  }

  # See ha::* for available implementations.
}
