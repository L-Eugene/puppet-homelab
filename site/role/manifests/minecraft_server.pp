# Class: role::minecraft_server
# This class sets up the Minecraft server by including necessary profiles.
#
# Parameters: None
#
# Example:
#   include role::minecraft_server
class role::minecraft_server {
  include profile::lab_timezone
  include profile::docker_compose
  include profile::minecraft_server
}
