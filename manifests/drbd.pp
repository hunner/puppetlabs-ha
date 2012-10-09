class ha::drbd (
  $mountpoint,
  $owner    = $ha::params::owner,
  $group    = $ha::params::group,
  $resource = $ha::resource,
) inherits ha {
  class { 'ha::util::drbd':
    mountpoint => $mountpoint,
    owner      => $owner,
    group      => $group,
  }
  ha::drbd::corosync { $resource: }
}
