class profile::timezone(
  String $timezone,
) {
  class { 'timezone':
    timezone => $timezone,
  }
}
