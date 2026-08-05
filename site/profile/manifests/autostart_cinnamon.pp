# @summary Configures XDG autostart for Eugene on galeon
class profile::autostart_cinnamon {
  $autostart_dir = '/home/eugene/.config/autostart'

  file { $autostart_dir:
    ensure => directory,
    owner  => 'eugene',
    group  => 'eugene',
    mode   => '0755',
  }

  file { [
    "${autostart_dir}/disable-dpms.desktop",
    "${autostart_dir}/gnote.desktop",
  ]:
    ensure => absent,
    force  => true,
  }
}
