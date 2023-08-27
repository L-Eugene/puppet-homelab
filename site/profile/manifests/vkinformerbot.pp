class profile::vkinformerbot {
  file { '/opt/vkinformer':
    ensure => directory,
  }

  file { '/opt/vkinformer/docker-compose.yml':
    ensure => file,
    content => epp(
      'telegram_bot/docker-compose.yml.epp', 
      { 
        'bot_image' => 'elapeko/vkinformerbot',  
        'bot_volumes' => ['./vk_informer_bot.rb.yml:/usr/src/app/vk_informer_bot.rb.yml']
      }
    )
  }

  $vkinformer_user = lookup('vkinformer_user')
  $vkinformer = lookup('vk_informer')

  file { '/opt/vkinformer/vk_informer_bot.rb.yml':
    ensure => file,
    content => epp(
      'telegram_bot/botconfig.yml.epp',
      { 
        'debug' => false,
        'db_host'  => $vkinformer['db']['db_host'],
        'db_name'  => $vkinformer['db']['db_name'],
        'db_user'  => $vkinformer_user['username'],
        'db_pass'  => $vkinformer_user['password'],
        'tg_token' => $vkinformer['tg']['token'],
      }
    )
  }

  systemd::manage_unit { 'vkinformer.service':
    unit_entry    => {
      'Description' => 'VK Informer Telegram bot',
      'PartOf'      => 'docker.service',
      'After'       => 'docker.service',
    },
    service_entry => {
      'Type'              => 'oneshot',
      'RemainAfterExit'   => true,
      'WorkingDirectory'  => '/opt/vkinformer/',
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
