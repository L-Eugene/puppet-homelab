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
