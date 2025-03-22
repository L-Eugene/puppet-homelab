# This class configures the network connections on the system.
class profile::network_config {
  $configs = lookup('network_config')
  create_resources('networkmanager::connection', $configs)
/*
  networkmanager::connection { 'ass-teriks':
    content => {
      connection    => {
        'id'          => 'ass-teriks',
        'type'        => 'wifi',
        'permissions' => ''
      },
      wifi          => {
        'ssid' => 'ass-teriks',
        'mode' => 'infrastructure'
      },
      wifi-security => {
        'key-mgmt' => 'wpa-psk',
        'psk'      => 'password'
      },
      ipv4          => {
        'dns-search' => '',
        'method'     => 'auto'
      },
      ipv6          => {
        'dns-search'    => '',
        'method'        => 'auto',
        'addr-gen-mode' => 'stable-privacy'
      }
    },
  }
  */
}
