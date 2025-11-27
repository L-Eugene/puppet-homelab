# @summary Manages private VPN server configuration
#
# This class configures an OpenVPN server for private network access,
# including certificate files, server configuration, routing rules,
# and firewall settings.
#
class profile::vpn_private {
  include openvpn::requirements

  $file_content = lookup('vpn_private')

  file { '/etc/openvpn/server/':
    ensure => directory,
    mode   => '0755',
    owner  => root,
    group  => root
  }

  file { '/etc/openvpn/server/ca.crt':
    ensure  => file,
    content => $file_content['ca'],
    mode    => '0644',
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/dh2048.pem':
    ensure  => file,
    content => $file_content['dh'],
    mode    => '0644',
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/vps.crt':
    ensure  => file,
    content => $file_content['cert'],
    mode    => '0644',
    owner   => root,
    group   => root
  }

  file { '/etc/openvpn/server/vps.key':
    ensure  => file,
    content => $file_content['key'],
    mode    => '0600',
    owner   => root,
    group   => root
  }

  openvpn::server  {'server':
    server_name   => 'server',
    server_config => {
        'port'                  => 1194,
        'proto'                 => 'tcp',
        'dev'                   => 'tun',
        'ca'                    => '/etc/openvpn/server/ca.crt',
        'cert'                  => '/etc/openvpn/server/vps.crt',
        'key'                   => '/etc/openvpn/server/vps.key',
        'dh'                    => '/etc/openvpn/server/dh2048.pem',
        'topology'              => 'subnet',
        'server'                => '10.201.0.0 255.255.255.0',
        'ifconfig-pool-persist' => '/etc/openvpn/server/ipp.txt',
        'push'                  => [
            '"route 192.168.14.0 255.255.255.0"',
            '"route 192.168.32.0 255.255.255.0"',
            '"route 192.168.92.0 255.255.255.0"',
            '"route 192.168.116.0 255.255.255.0"',
        ],
        'client-config-dir'     => '/etc/openvpn/server/ccd',
        'client-to-client'      => '',
        'keepalive'             => '10 120',
        'cipher'                => 'AES-256-CBC',
        'auth'                  => 'SHA1',
        'persist-key'           => '',
        'persist-tun'           => ''
    },
    ccd_options   => {
      'sofia'     => { 'iroute' => '192.168.116.0 255.255.255.0' },
      'gaidara'   => { 'iroute' => '192.168.14.0 255.255.255.0' },
      'chonki'    => { 'iroute' => '192.168.92.0 255.255.255.0' },
      'amur-comp' => { 'iroute' => '192.168.32.0 255.255.255.0' },
    }
  }

  firewall { '100 snat for private openvpn':
    chain    => 'POSTROUTING',
    jump     => 'MASQUERADE',
    proto    => 'all',
    outiface => 'eth0',
    source   => '10.201.0.0/24',
    table    => 'nat',
  }

  sysctl { 'net.ipv4.ip_forward':
    value => 1,
  }
}
