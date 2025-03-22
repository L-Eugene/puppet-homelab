define networkmanager::reload {
  exec { 'nmcli conn reload':
    command     => '/usr/bin/nmcli conn reload',
    refreshonly => true,
  }
}
