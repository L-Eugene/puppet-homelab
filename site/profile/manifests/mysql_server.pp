class profile::mysql_server {
  class { 'mysql::server':
    restart                 => true,
    reload_on_config_change => true,
    override_options        => {
      'mysqld' => {
        'bind-address' => '0.0.0.0'
      }
    }
  }
}
