class profile::mysql_server {
  class { 'mysql::server':
    restart => true,
  }
}
