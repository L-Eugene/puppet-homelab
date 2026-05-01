# @summary Configure UTF-8 locale for puppet-agent systemd service.
#
# This profile manages a systemd drop-in so puppet-agent runs with UTF-8
# locale settings, preventing encoding errors in Ruby-based providers.
#
# @param lang
#   Value for LANG in puppet-agent service environment.
# @param lc_all
#   Value for LC_ALL in puppet-agent service environment.
class profile::puppet_agent_locale (
  String $lang = 'C.UTF-8',
  String $lc_all = 'C.UTF-8',
) {
  file { '/etc/systemd/system/puppet-agent.service.d':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { '/etc/systemd/system/puppet-agent.service.d/locale.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    require => File['/etc/systemd/system/puppet-agent.service.d'],
    notify  => Exec['systemd-daemon-reload-puppet-agent-locale'],
    content => @("CONF")
[Service]
Environment=LANG=${lang}
Environment=LC_ALL=${lc_all}
| CONF
  }

  exec { 'systemd-daemon-reload-puppet-agent-locale':
    command     => '/bin/systemctl daemon-reload',
    path        => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
    refreshonly => true,
  }
}
