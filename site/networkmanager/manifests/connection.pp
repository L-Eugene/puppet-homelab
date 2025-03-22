define networkmanager::connection(
  Hash[String, Hash] $content,
  Enum['present', 'absent'] $ensure = 'present'
) {
  $_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file'
  }

  file { "/etc/NetworkManager/system-connections/${title}":
    ensure  => $_ensure,
    content => extlib::to_ini($content, { 'quote_char' => undef }),
    mode    => '0600',
    owner   => 'root',
    notify  => Exec['nmcli conn reload'],
  }
}
