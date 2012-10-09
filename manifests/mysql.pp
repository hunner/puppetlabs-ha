class ha::mysql (
  $datadir,
  $resource    = $ha::resource,
  $vip         = $ha::vip,
  $manage_user = $ha::params::manage_user,
) inherits ha {
  if $manage_user {
    user { 'mysql':
      ensure => present,
      gid    => 'mysql',
      system => true,
    }
    group { 'mysql':
      ensure => present,
      system => true,
    }
  }
  class { 'ha::util::vip': }
  class { 'ha::util::drbd':
    mountpoint => $datadir,
    owner      => 'mysql',
    group      => 'mysql',
  }
  ha::mysql::corosync { $resource: }
}
