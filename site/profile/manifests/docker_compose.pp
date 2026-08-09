class profile::docker_compose {
  # Use official distro repositories for Linux Mint and Ubuntu 26.04+, where
  # Docker is available as docker.io instead of docker-ce.
  # Ubuntu 26.04+ also uses docker-compose-v2 in the official repos.
  $use_official_repo = ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '26') >= 0) or
                       ($facts['os']['name'] == 'LinuxMint')

  if $use_official_repo {
    class { 'docker':
      log_driver                  => 'journald',
      use_upstream_package_source => false,
      docker_ce_package_name      => 'docker.io',
    }

    package { 'docker-compose-v2':
      ensure => present,
    }
  } else {
    # Use upstream Docker repositories for earlier Ubuntu versions
    class { 'docker':
      log_driver                   => 'journald',
      use_upstream_package_source  => true,
    }

    # Use module's default docker-compose-plugin package for upstream repos
    include 'docker::compose'
  }
}
