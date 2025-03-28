# This class configures the network connections on the system.
class profile::network_config {
  $files = lookup('network_config_files')
  create_resources('file', $files)

  $configs = lookup('network_config')
  create_resources('networkmanager::connection', $configs)

  file { 'homm_ufw_app':
    ensure => 'file',
    path   => '/etc/ufw/applications.d/homm',
    source => 'puppet:///modules/profile/etc/ufw/applications.d/homm'
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

  $network_auto_scripts = ['50-wifi-manipulation', '51-dns-routes', 'ipv4lib.sh' ]
  $network_auto_scripts.each |$script| {
    file { "network_auto_script_${script}":
      ensure => 'file',
      path   => "/etc/NetworkManager/dispatcher.d/${script}",
      source => "puppet:///modules/profile/etc/NetworkManager/dispatcher.d/${script}",
      mode   => '0700',
      owner  => 'root',
      group  => 'root',
      notify => Service['NetworkManager'],
    }
  }

  service { 'NetworkManager':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
  }
}
