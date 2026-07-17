class profile::docker_compose {
  class { 'docker':
    log_driver                   => 'journald',
    use_upstream_package_source  => true,
  }

  include 'docker::compose'
}
