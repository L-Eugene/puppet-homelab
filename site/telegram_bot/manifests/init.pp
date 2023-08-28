class telegram_bot (
  String $bot_config_file = "${$name}.rb.yml",
  String $bot_image,
  String $bot_app_path = '/usr/src/app',
  Array  $bot_volumes = [],
  Boolean $bot_debug = false,
  String $bot_token = 'UNDEFINED',
  Hash   $bot_database = {}
) {
  file { "/opt/${$name}":
    ensure => directory,
  }

  file { "/opt/${$name}/docker-compose.yml":
    ensure => file,
    content => epp(
      'telegram_bot/docker-compose.yml.epp', 
      { 
        'bot_image'   => $bot_image,  
        'bot_volumes' => ["./${$bot_config_file}:${$bot_app_path}/${$bot_config_file}"] + $bot_volumes,
      }
    )
  }

  $config_parameters = { 'db_name' => '', 'db_pass' => '' } + { 'debug' => $bot_debug } + $bot_database

  file { "/opt/${$name}/${$bot_config_file}":
    ensure => file,
    content => epp('telegram_bot/botconfig.yml.epp', $config_parameters)
  }

  systemd::manage_unit { "${$name}.service":
    unit_entry    => {
      'Description' => "${$name} Telegram bot",
      'PartOf'      => 'docker.service',
      'After'       => 'docker.service',
    },
    service_entry => {
      'Type'              => 'oneshot',
      'RemainAfterExit'   => true,
      'WorkingDirectory'  => "/opt/${$name}/",
      'ExecStart'         => 'docker-compose up -d --remove-orphans',
      'ExecStop'          => 'docker-compose down',
    },
    install_entry => {
      'WantedBy' => 'multi-user.target',
    },
    enable        => true,
    active        => true,
  }
}
