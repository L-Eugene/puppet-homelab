node default {
}

node 'mysql-server.lan' {
  include role::mysql_server
}

node 'puppet-master.lan' {
  include role::puppet_master
}
