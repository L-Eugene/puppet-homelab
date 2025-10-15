class profile::vpn_static {
  include openvpn::requirements

  $file_content = lookup('vpn_static')

  file { '/etc/openvpn/static_server/':
    ensure => directory,
    mode   => '0755',
    owner  => root,
    group  => root
  }

  file { '/etc/openvpn/static_server/static.key':
    ensure  => file,
    content => $file_content['key'],
    mode    => '0644',
    owner   => root,
    group   => root
  }

  openvpn::server  {'static_server':
    server_config => {
        'dev'         => 'tun',
        'ifconfig'    => '10.8.0.1 10.8.0.2',
        'secret'      => '/etc/openvpn/static_server/static.key',
        'port'        => 1194,
        'proto'       => 'udp',
        'keepalive'   => '10 120',
        'persist-key' => '',
        'persist-tun' => '',
        'log'         => '/var/log/openvpn/static_server.log',
        'topology'    => undef,
        'user'        => undef,
        'group'       => undef,
        'status'      => undef,
        'log-append'  => undef,
    }
  }

  sysctl { 'net.ipv4.ip_forward':
    value => 1,
  }

  firewall { '100 snat for static openvpn':
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    proto    => 'all',
    outiface => 'eth0',
    source   => '10.8.0.0/24',
    table    => 'nat',
  }
}
