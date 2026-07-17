node default {
}

node 'mysql-server.lan' {
  include role::mysql_server
}

node 'bot-server.lan' {
  include role::bot_server
}

node 'puppet-master.lan' {
  include role::puppet_master
}

node 'openvpn.lan' {
  include role::openvpn_server
}

node 'minecraft.lan' {
  include role::minecraft_server
}

node 'mediaserver.lan' {
  include role::media_server
}

node 'oasis' {
  include role::media_server
}

node 'galeon' {
  include role::development_machine
}
