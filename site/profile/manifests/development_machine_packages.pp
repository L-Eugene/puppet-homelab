class profile::development_machine_packages {
  package { 'hiera-eyaml':
    ensure => present,
  }
}
