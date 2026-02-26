class profile::puppet_cleanup_reports {
  cron { 'puppet_cleanup_reports':
    ensure  => present,
    command => '/usr/bin/find /opt/puppetlabs/server/data/puppetserver/reports -type f -mtime +30 -exec /bin/rm {} ";"',
    user    => 'root',
    hour    => 5,
    minute  => 0,
  }
}
