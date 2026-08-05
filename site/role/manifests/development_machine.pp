class role::development_machine {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::vscode_flatpak
  include profile::docker_compose
  include profile::autostart_cinnamon
}
