# Class: profile::bablobot
#
# This class manages the deployment and configuration of the Bablobot application.
#
# Parameters:
#   None
#
class profile::bablobot {
  file { '/opt/bablobot':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  $bablobot_config = lookup('bablobot')

  file { '/opt/bablobot/config.yml':
    ensure  => file,
    content => inline_template('<%= @bablobot_config.to_yaml %>'),
    require => File['/opt/bablobot'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  cron { 'bablobot_weekly_job':
    ensure  => present,
    command => "docker pull ghcr.io/l-eugene/bablobot/bablobot:latest && \
          docker run -v /opt/bablobot/config.yml:/usr/src/app/config.yml --rm \
          ghcr.io/l-eugene/bablobot/bablobot:latest --output=chat",
    user    => 'root',
    hour    => 18,
    minute  => 0,
    weekday => '5',
  }
}
