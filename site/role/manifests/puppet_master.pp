class role::puppet_master {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::hiera_eyaml
  include profile::puppet_cleanup_reports
}
