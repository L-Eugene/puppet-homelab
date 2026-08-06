# Class: role::bot_server
# This class sets up the bot server by including necessary profiles.
#
# Parameters: None
#
# Example:
#   include role::bot_server
class role::bot_server {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::ssh_root_auth
  include profile::docker_compose
  include profile::vkinformerbot
  include profile::bablobot
}
