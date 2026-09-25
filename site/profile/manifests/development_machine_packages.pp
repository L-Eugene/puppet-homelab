class profile::development_machine_packages {
  package { 'hiera-eyaml':
    ensure => present,
  }

  # --- WineHQ upstream repo ---
  # Installed wine (9.0~repack) comes from the distro, not WineHQ.
  file { '/etc/apt/sources.list.d/wine-hq.list':
    ensure => absent,
    notify => Class['apt::update'],
  }
  exec { 'remove-winehq-legacy-key':
    command => '/usr/bin/gpg --batch --yes --no-default-keyring --keyring /etc/apt/trusted.gpg --delete-keys D43F640145369C51D786DDEA76F1A20FF987672F',
    onlyif  => '/usr/bin/gpg --no-default-keyring --keyring /etc/apt/trusted.gpg --list-keys D43F640145369C51D786DDEA76F1A20FF987672F 2>/dev/null',
  }

  # --- Ansible PPA ---
  # Key goes directly into trusted.gpg.d (binary format) via curl+dearmor,
  # bypassing the deprecated apt-key path that apt::key { id, server } uses.
  file { '/etc/apt/sources.list.d/ppa_ansible_ansible_focal.list':
    ensure => absent,
    notify => Class['apt::update'],
  }
  exec { 'download-ansible-ppa-key':
    command => '/usr/bin/curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | /usr/bin/gpg --dearmor -o /etc/apt/trusted.gpg.d/ansible-ppa.gpg',
    creates => '/etc/apt/trusted.gpg.d/ansible-ppa.gpg',
    notify  => Class['apt::update'],
  }
  apt::source { 'ansible':
    location => 'http://ppa.launchpad.net/ansible/ansible/ubuntu',
    release  => 'noble',
    repos    => 'main',
    require  => [
      File['/etc/apt/sources.list.d/ppa_ansible_ansible_focal.list'],
      Exec['download-ansible-ppa-key'],
    ],
  }

  # --- Telegram PPA (atareao) ---
  # Same approach. Note: the PPA's signing key is RSA-1024 (weak by modern
  # standards); that is the PPA author's limitation, not fixable on our side.
  file { '/etc/apt/sources.list.d/atareao-telegram-focal.list':
    ensure => absent,
    notify => Class['apt::update'],
  }
  exec { 'download-telegram-ppa-key':
    command => '/usr/bin/curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xA3D8A366869FE2DC5FFD79C36A9653F936FD5529" | /usr/bin/gpg --dearmor -o /etc/apt/trusted.gpg.d/telegram-ppa.gpg',
    creates => '/etc/apt/trusted.gpg.d/telegram-ppa.gpg',
    notify  => Class['apt::update'],
  }
  apt::source { 'telegram-atareao':
    location => 'http://ppa.launchpad.net/atareao/telegram/ubuntu',
    release  => 'noble',
    repos    => 'main',
    require  => [
      File['/etc/apt/sources.list.d/atareao-telegram-focal.list'],
      Exec['download-telegram-ppa-key'],
    ],
  }
}
