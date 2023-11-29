class openvpn::dir {
  file { '/etc/openvpn/':
    ensure  => directory,
    mode    => "0755",
    owner   => root,
    group   => root
  }
}