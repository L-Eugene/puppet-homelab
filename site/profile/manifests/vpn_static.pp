class profile::vpn_static {
  include openvpn::requirements

  $file_content = lookup('vpn_static')

  file { '/etc/openvpn/static_server/static.key':
    ensure  => absent
  }

  file { '/etc/openvpn/static_server.conf':
    ensure  => absent
  }

  file { '/etc/openvpn/static_server/':
    ensure => absent,
    force  => true
  }
}
