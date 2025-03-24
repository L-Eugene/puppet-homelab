# This class configures the network connections on the system.
class profile::network_config {
  $files = lookup('network_config_files')
  create_resources('file', $files)

  $configs = lookup('network_config')
  create_resources('networkmanager::connection', $configs)
}
