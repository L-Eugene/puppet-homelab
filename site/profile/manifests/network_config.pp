# This class configures the network connections on the system.
class profile::network_config {
  $files = lookup('network_config_files')
  create_resources('file', $files)

  $configs = lookup('network_config')
  create_resources('networkmanager::connection', $configs)

  file { 'homm_ufw_app':
    ensure  => 'file',
    path    => '/etc/ufw/applications.d/homm',
    content => @(EOD)
    [HoMM]
    title=Heroes of Might and Magic III
    description=Heroes of Might and Magic III LAN Multiplayer
    ports=2300,47624/tcp|2350,47624,10062,15114,16702,2252,29474,30957,33352,36197,37818,42268,46384,46747,48053,51514,58930,8470/udp
    |-EOD
  }

  class { 'ufw':
    manage_package        => true,
    package_name          => 'ufw',
    manage_service        => true,
    service_name          => 'ufw',
    service_ensure        => 'running',
    purge_unmanaged_rules => true,
    rules                 => {
      'allow_ssh'      => {
        'ensure'       => 'present',
        'action'       => 'allow',
        'to_ports_app' => 22,
        'proto'        => 'tcp'
      },
      'allow_homm' => {
        'ensure'       => 'present',
        'action'       => 'allow',
        'to_ports_app' => 'HoMM',
      },
    },
  }
}
