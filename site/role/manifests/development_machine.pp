class role::development_machine {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::vscode_flatpak
}
