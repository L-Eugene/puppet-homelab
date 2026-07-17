class profile::torrentbot {
  $torrentbot_dir = '/srv/'
  $downloads_link = '/srv/downloads'
  $env            = lookup('profile::torrentbot::env', Hash[String, String])

  # Ensure /srv directory exists
  file { $torrentbot_dir:
    ensure => directory,
    mode   => '0755',
  }

  archive { "${torrentbot_dir}/docker-compose.yml":
    ensure  => present,
    source  => 'https://raw.githubusercontent.com/OksLo/torrentbot/main/docker-compose.yml',
    require => File[$torrentbot_dir],
  }

  archive { "${torrentbot_dir}/setup.py":
    ensure  => present,
    source  => 'https://raw.githubusercontent.com/OksLo/torrentbot/main/setup.py',
    require => File[$torrentbot_dir],
  }

  # Create .env file
  file { "${torrentbot_dir}/.env":
    ensure  => file,
    mode    => '0600',
    content => Sensitive(join([$env.map |$k, $v| { "${k}=${v}" }.join("\n"), "\n"])),
    require => File[$torrentbot_dir],
  }

  # Create symlink for downloads directory
  file { $downloads_link:
    ensure  => link,
    target  => '/media/Video',
    require => File[$torrentbot_dir],
  }

  exec { 'systemd-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }


  # Create systemd unit file
  systemd::unit_file { 'torrentbot.service':
    content => @("EOT"/L),
      [Unit]
      Description=TorrentBot Docker Compose Service
      After=network-online.target docker.service
      Wants=network-online.target
      Requires=docker.service

      [Service]
      Type=oneshot
      WorkingDirectory=${torrentbot_dir}
      ExecStart=/usr/bin/docker compose up -d --remove-orphans
      ExecStop=/usr/bin/docker compose down
      RemainAfterExit=yes

      [Install]
      WantedBy=multi-user.target
      | EOT
    require => Archive["${torrentbot_dir}/docker-compose.yml"],
    notify  => Exec['systemd-reload']
  }

  service { 'torrentbot':
    ensure  => running,
    enable  => true,
    require => Systemd::Unit_file['torrentbot.service'],
  }
}
