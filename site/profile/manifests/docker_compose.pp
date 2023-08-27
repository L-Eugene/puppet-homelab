class profile::docker_compose {
  class { 'docker':
    log_driver => 'syslog',
  }

  include 'docker::compose'
}
