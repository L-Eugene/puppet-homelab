class profile::vpn_academy {
  include openvpn::dir

  $file_content = lookup('vpn_academy')

  file { '/etc/openvpn/academy/':
    ensure  => directory,
    mode    => "0755",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/academy/ca.crt':
    ensure  => file,
    content => $file_content['ca'],
    mode    => "0644",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/academy/dh.pem':
    ensure  => file,
    content => $file_content['dh'],
    mode    => "0644",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/academy/vps.crt':
    ensure  => file,
    content => $file_content['cert'],
    mode    => "0644",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/academy/vps.key':
    ensure  => file,
    content => $file_content['key'],
    mode    => "0600",
    owner   => root,
    group   => root
  }

  openvpn::server {'academy':
    server_config => {
        'port' => 1195,
        'proto' => 'tcp',
        'dev' => 'tun',
        'ca' => '/etc/openvpn/academy/ca.crt',
        'cert' => '/etc/openvpn/academy/vps.crt',
        'key' => '/etc/openvpn/academy/vps.key',
        'dh' => '/etc/openvpn/academy/dh.pem',
        'topology' => 'subnet',
        'server' => '10.202.0.0 255.255.255.0',
        'ifconfig-pool-persist' => '/etc/openvpn/academy/ipp.txt',
        'push' => [
            '"route 172.20.6.0 255.255.255.0"',
            '"route 172.20.7.0 255.255.255.0"',
            '"route 192.168.20.0 255.255.255.0"',
        ],
        'client-config-dir' => '/etc/openvpn/academy/ccd',
        'client-to-client' => undef,
        'keepalive' => '10 120',
        'cipher' => 'AES-256-CBC',
        'auth' => 'SHA1',
        'max-clients' => 100,
        'persist-key' => undef,
        'persist-tun' => undef
    },
    ccd_options => {
      'itacademy-mikrotik' => { 
        'iroute' => [
          '172.20.6.0 255.255.255.0',
          '172.20.7.0 255.255.255.0',
          '192.168.20.0 255.255.255.0',
        ]
      }
    }
  }
}