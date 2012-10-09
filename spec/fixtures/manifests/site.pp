node 'ha.novip.mysql.host' {
  class { 'ha':
    cluster => 'mock_cluster',
    disk    => '/dev/mock_disk',
    members => [
      '10.0.0.3',
      '10.0.0.2',
    ],
  }

  class { 'ha::mysql':
    datadir => '/var/lib/mock',
  }
}

node 'ha.vip.mysql.host' {
  class { 'ha':
    cluster => 'mock_cluster',
    disk    => '/dev/mock_disk',
    vip     => '23.23.23.23',
    members => [
      '10.0.0.3',
      '10.0.0.2',
    ],
  }

  class { 'ha::mysql':
    datadir => '/var/lib/mock',
  }
}

node 'ha.vip.host' {
  class { 'ha':
    cluster => 'mock_cluster',
    disk    => '/dev/mock_disk',
    vip     => '23.23.23.23',
    members => [
      '10.0.0.3',
      '10.0.0.2',
    ],
  }

  class { 'ha::vip': }
}

node default {
}
