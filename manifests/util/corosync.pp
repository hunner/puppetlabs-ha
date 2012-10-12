class ha::util::corosync (
  $cluster         = $ha::cluster,
  $members         = $ha::members,
  $ca_cert         = $ha::ca_cert,
  $check_standby   = $ha::check_standby,
  $resource        = $ha::resource,
  $stonith_enabled = $ha::stonith_enabled,
  $stickiness      = $ha::stickiness
) {
  # Corosync + Pacemaker configuration
  anchor { 'ha::util::corosync::begin': }
  -> class { '::corosync':
    enable_secauth    => false,
    authkey           => $ca_cert,
    unicast_addresses => unique(sort(flatten($members))),
    check_standby     => $check_standby,
  }
  -> anchor { 'ha::util::corosync::end': }
  service { 'pacemaker':
    ensure  => stopped,
    require => Package['pacemaker'],
    before  => [
      Service['corosync'],
      ::Corosync::Service['pacemaker'],
  }
  ::corosync::service { 'pacemaker':
    version => '0',
    require => [Package['corosync'], Package['pacemaker']],
    notify  => Service['corosync'],
  }
  # Needed for two-node clusters:
  cs_property { 'no-quorum-policy':
    value => 'ignore',
  }

  if $stickiness {
    cs_property { 'default-resource-stickiness':
      value   => $stickiness,
    }
  }
  # WARNING: STONITH is being disabled due to the complexity and time
  # constraints. SCEA should ensure that STONITH is configured before using
  # drbd-failover in production.
  cs_property { 'stonith-enabled':
    value  => $stonith_enabled,
  }

  cs_shadow { $resource: }
  Cs_property <| |> -> Cs_shadow <| |>
}
