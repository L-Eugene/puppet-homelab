# Class: role::minecraft_server
# This class sets up the Minecraft server by including necessary profiles.
#
# Parameters: None
#
# Example:
#   include role::minecraft_server
class role::minecraft_server {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::docker_compose
  include profile::minecraft_server
}
