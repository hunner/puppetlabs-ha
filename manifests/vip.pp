class ha::vip (
  $resource = $ha::resource,
  $vip      = $ha::vip_real,
) inherits ha {
  class { 'ha::util::corosync': }
  if $vip {
    class { 'ha::util::vip':
      resource => $resource,
      vip      => $vip,
    }
  }
  include corosync::reprobe
}
