# @summary Configures XDG autostart for Eugene on galeon
class profile::autostart_cinnamon {
  $autostart_dir = '/home/eugene/.config/autostart'
  $desktop_file  = "${autostart_dir}/xset-dpms.desktop"

  file { $autostart_dir:
    ensure => directory,
    owner  => 'eugene',
    group  => 'eugene',
    mode   => '0755',
  }

  file { $desktop_file:
    ensure  => file,
    owner   => 'eugene',
    group   => 'eugene',
    mode    => '0644',
    content => "[Desktop Entry]\nType=Application\nName=DPMS timeout\nExec=xset dpms 600 600 600\nTerminal=false\nX-GNOME-Autostart-enabled=true\n",
  }
}
