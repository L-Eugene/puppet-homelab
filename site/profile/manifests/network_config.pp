# This class configures the network connections on the system.
class profile::network_config {
  $configs = lookup('network_config')
  create_resources('networkmanager::connection', $configs)
}
