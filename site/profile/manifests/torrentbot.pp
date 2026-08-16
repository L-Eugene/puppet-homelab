class profile::torrentbot (
  Boolean $gpu_enabled = true,
) {
  $torrentbot_dir = '/srv/'
  $downloads_link = '/srv/downloads'
  $torrentbot_repo = 'https://raw.githubusercontent.com/OksLo/torrentbot/main'
  $env            = lookup('profile::torrentbot::env', Hash[String, String])
  $docker_compose_flags = $gpu_enabled ? {
    true    => '-f docker-compose.yml -f docker-compose.gpu.yml',
    default => '-f docker-compose.yml',
  }
  $compose_require = $gpu_enabled ? {
    true    => [Exec['download-torrentbot-docker-compose'], Exec['download-torrentbot-docker-compose-gpu']],
    default => Exec['download-torrentbot-docker-compose'],
  }

  # Ensure /srv directory exists
  file { $torrentbot_dir:
    ensure => directory,
    mode   => '0755',
  }

  exec { 'download-torrentbot-docker-compose':
    command => "/usr/bin/curl -fsSL -o ${torrentbot_dir}/docker-compose.yml ${torrentbot_repo}/docker-compose.yml",
    unless  => "/usr/bin/curl -fsSL ${torrentbot_repo}/docker-compose.yml | /usr/bin/cmp -s - ${torrentbot_dir}/docker-compose.yml",
    path    => ['/usr/bin', '/bin'],
    require => File[$torrentbot_dir],
  }

  if $gpu_enabled {
    exec { 'download-torrentbot-docker-compose-gpu':
      command => "/usr/bin/curl -fsSL -o ${torrentbot_dir}/docker-compose.gpu.yml ${torrentbot_repo}/docker-compose.gpu.yml",
      unless  => "/usr/bin/curl -fsSL ${torrentbot_repo}/docker-compose.gpu.yml | /usr/bin/cmp -s - ${torrentbot_dir}/docker-compose.gpu.yml",
      path    => ['/usr/bin', '/bin'],
      require => File[$torrentbot_dir],
    }
  } else {
    file { "${torrentbot_dir}/docker-compose.gpu.yml":
      ensure => absent,
    }
  }

  file { "${torrentbot_dir}/setup.py":
    ensure => absent,
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
      ExecStart=/usr/bin/docker compose ${docker_compose_flags} up -d --remove-orphans
      ExecStop=/usr/bin/docker compose ${docker_compose_flags} down
      RemainAfterExit=yes

      [Install]
      WantedBy=multi-user.target
      | EOT
    require => $compose_require,
    notify  => Exec['systemd-reload']
  }

  # Oneshot service that pulls fresh images and recreates changed containers
  systemd::unit_file { 'torrentbot-update.service':
    content => @("EOT"/L),
      [Unit]
      Description=TorrentBot Docker Image Updater
      After=network-online.target docker.service
      Wants=network-online.target
      Requires=docker.service

      [Service]
      Type=oneshot
      WorkingDirectory=${torrentbot_dir}
      ExecStart=/usr/bin/docker compose ${docker_compose_flags} pull
      ExecStartPost=/usr/bin/docker compose ${docker_compose_flags} up -d --remove-orphans
      | EOT
    require => $compose_require,
    notify  => Exec['systemd-reload'],
  }

  # Daily timer that triggers the update service
  systemd::unit_file { 'torrentbot-update.timer':
    content => @(EOT/L),
      [Unit]
      Description=TorrentBot Docker Image Update Timer

      [Timer]
      OnCalendar=*-*-* 04:00:00
      RandomizedDelaySec=1800
      Persistent=true
      Unit=torrentbot-update.service

      [Install]
      WantedBy=timers.target
      | EOT
    require => Systemd::Unit_file['torrentbot-update.service'],
    notify  => Exec['systemd-reload'],
  }

  service { 'torrentbot':
    ensure  => running,
    enable  => true,
    require => Systemd::Unit_file['torrentbot.service'],
  }

  service { 'torrentbot-update.timer':
    ensure  => running,
    enable  => true,
    require => Systemd::Unit_file['torrentbot-update.timer'],
  }
}
