class profile::docker_compose {
  # Ubuntu 26.04+ has docker in official repos; use those instead of upstream
  $use_upstream_repo = if ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '26') >= 0) {
    false
  } else {
    true
  }

  class { 'docker':
    log_driver                   => 'journald',
    use_upstream_package_source  => $use_upstream_repo,
  }

  include 'docker::compose'
}
