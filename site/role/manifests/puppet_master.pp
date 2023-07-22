class role::puppet_master {
  include profile::lab_timezone
  include profile::hiera_eyaml
}
