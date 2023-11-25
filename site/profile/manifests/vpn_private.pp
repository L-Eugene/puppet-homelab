class profile::vpn_private {
  $file_content = lookup('vpn_private')

  file { '/etc/openvpn/':
    ensure  => directory,
    mode    => "0755",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/':
    ensure  => directory,
    mode    => "0755",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/ca.crt':
    ensure  => file,
    content => $file_content['ca'],
    mode    => "0644",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/dh2048.pem':
    ensure  => file,
    content => $file_content['dh'],
    mode    => "0644",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/vps.crt':
    ensure  => file,
    content => $file_content['cert'],
    mode    => "0644",
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/vps.key':
    ensure  => file,
    content => $file_content['key'],
    mode    => "0600",
    owner   => root,
    group   => root
  }

  class {'openvpn':
    server_name => 'server',
    server_config => {
        'port' => 1194,
        'proto' => 'tcp',
        'dev' => 'tun',
        'ca' => '/etc/openvpn/server/ca.crt',
        'cert' => '/etc/openvpn/server/vps.crt',
        'key' => '/etc/openvpn/server/vps.key',
        'dh' => '/etc/openvpn/server/dh2048.pem',
        'topology' => 'subnet',
        'server' => '10.201.0.0 255.255.255.0',
        'ifconfig-pool-persist' => '/etc/openvpn/server/ipp.txt',
        'push' => [
            '"route 192.168.14.0 255.255.255.0"',
            '"route 192.168.32.0 255.255.255.0"',
            '"route 192.168.92.0 255.255.255.0"',
            '"route 192.168.116.0 255.255.255.0"',
        ],
        'client-config-dir' => '/etc/openvpn/server/ccd',
        'client-to-client' => undef,
        'keepalive' => '10 120',
        'cipher' => 'AES-256-CBC',
        'auth' => 'SHA1',
        'persist-key' => undef,
        'persist-tun' => undef
    }
  }
}
