class ha::params {
  $resource = 'puppet_ha'

  #mysql specific
  $manage_user = true

  #drbd specific
  $format = true
  $owner = 'root'
  $group = 'root'
  $device = '/dev/drbd0'

  #corosync specific
  $stonith_enabled = true
  $stickiness = false
  $check_standby = true
  if $::puppetversion =~ /Puppet Enterprise/ {
    $ca_cert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'
  } else {
    $ca_cert = '/etc/puppet/ssl/certs/ca.pem'
  }
}
