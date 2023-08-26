class profile::vkinformerbot {
  file { '/opt/vkinformer':
    ensure => directory,
  }

  file { '/opt/vkinformer/docker-compose.yml':
    ensure => file,
    content => epp(
      'telegram_bot/docker-compose.yml.epp', 
      { 
        'bot_image' => 'L-Eugene/vkinformerbot',  
        'bot_volumes' => ['vk_informer_bot.rb.yml:/usr/src/app/vk_informer_bot.rb.yml']
      }
    )
  }

  $vkinformer_user = lookup('vkinformer_user')
  $vkinformer_base = lookup('vk_informer_db')

  file { '/opt/vkinformer/vk_informer_bot.rb.yml':
    ensure => file,
    content => epp(
      'telegram_bot/botconfig.yml.epp',
      { 
        'debug' => false,
        'db_host' => $vkinformer_base['db_host'],
        'db_name' => $vkinformer_base['db_name'],
        'db_user' => $vkinformer_user['username'],
        'db_pass' => $vkinformer_user['password'],
      }
    )
  }
}
