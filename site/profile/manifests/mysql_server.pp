class profile::mysql_server {
  include mysql::server

  class { 'mysql::server':
    restart => true,
  }
}
