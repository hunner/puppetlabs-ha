define ha::drbd::corosync::second {
  $resource = $name
  # This is a define and a sub-define because of a fricking hack in puppet that
  # runs defines  and exported resource collections in alternating patterns. The
  # resource that we're searching for is two defineds deep in the DRBD module,
  # so we also need two defines.
  if defined(Drbd::Resource::Up[$resource]) {
    # We don't want corosync starting until drbd is available and finished
    class { 'ha::util::corosync':
      require => [
        Drbd::Resource::Up[$resource],
        Drbd::Resource[$resource],
        Anchor['ha::drbd::end'],
      ],
    }
    include corosync::reprobe
  }
}
