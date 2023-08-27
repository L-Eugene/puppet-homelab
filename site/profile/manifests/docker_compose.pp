class profile::docker_compose {
  class { 'docker':
    log_driver => 'journald',
  }

  include 'docker::compose'
}
