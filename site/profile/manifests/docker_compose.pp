class profile::docker_compose {
  # Ubuntu 26.04+ has docker in official repos with different package names
  # docker.io (instead of docker-ce) and docker-compose-v2 (instead of docker-compose-plugin)
  $use_ubuntu_repo = ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '26') >= 0)

  if $use_ubuntu_repo {
    # Use official Ubuntu repositories for Ubuntu 26.04+
    class { 'docker':
      log_driver                   => 'journald',
      use_upstream_package_source  => false,
      package_name                 => 'docker.io',
    }
  } else {
    # Use upstream Docker repositories for earlier Ubuntu versions
    class { 'docker':
      log_driver                   => 'journald',
      use_upstream_package_source  => true,
    }
  }

  include 'docker::compose'
}
