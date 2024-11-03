# Class: role::bot_server
# This class sets up the bot server by including necessary profiles.
#
# Parameters: None
#
# Example:
#   include role::bot_server
class role::bot_server {
  include profile::lab_timezone
  include profile::docker_compose
  include profile::vkinformerbot
  include profile::bablobot
}
