class ganglia::client::install {
  package {
    'ganglia-monitor': ensure => 'installed';
  }

  file { '/usr/lib/ganglia/python_modules':
    ensure => directory
  }

  file { '/usr/lib/ganglia/python_modules/diskstat.py':
    source  => 'puppet:///modules/ganglia/usr/lib/ganglia/python_modules/diskstat.py',
    require => File['/usr/lib/ganglia/python_modules']
  }

  file { '/etc/ganglia/conf.d/diskstat.pyconf':
    source  => 'puppet:///modules/ganglia/etc/ganglia/conf.d/diskstat.pyconf',
    require => File['/usr/lib/ganglia/python_modules']
  }

  file { '/etc/ganglia/gmond.conf':
    source  => 'puppet:///modules/ganglia/gmond.conf',
    owner   => root,
    group   => root,
    require => Package[ganglia-monitor],
  }
}
