class profile::ssh_root_auth {
  file_line { 'sshd PermitRootLogin':
    ensure => present,
    path   => '/etc/ssh/sshd_config',
    line   => 'PermitRootLogin yes',
    match  => '^PermitRootLogin',
    notify => Service['ssh'],
  }

  service { 'ssh':
    ensure => running,
    enable => true,
  }
}
