# This class configures the laptop role by including necessary profiles.
class role::laptop {
  include profile::lab_timezone
  include profile::network_config
}
