class profile::vscode_flatpak {
  package { 'flatpak':
    ensure => installed,
  }

  exec { 'flatpak-remote-add-flathub':
    command => '/usr/bin/flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo',
    path    => ['/usr/bin', '/bin'],
    unless  => '/usr/bin/flatpak remote-list --system | /bin/grep -qx flathub',
    require => Package['flatpak'],
  }

  exec { 'flatpak-install-vscode':
    command => '/usr/bin/flatpak install --system --assumeyes flathub com.visualstudio.code',
    path    => ['/usr/bin', '/bin'],
    unless  => '/usr/bin/flatpak info --system com.visualstudio.code',
    require => Exec['flatpak-remote-add-flathub'],
  }
}