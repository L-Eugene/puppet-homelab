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

  file { '/opt/vkinformer/vk_informer_bot.rb.yml':
    ensure => file,
    content => epp(
      'telegram_bot/botconfig.yml.epp',
      { 'debug' => false }
    )
  }
}
