class profile::lab_timezone {
  class { 'timezone':
    timezone => 'Europe/Sofia',
  }
}
