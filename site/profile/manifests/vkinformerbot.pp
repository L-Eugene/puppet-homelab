class profile::vkinformerbot {
  $vkinformer = lookup('vk_informer')

  class { 'telegram_bot':
    name            => 'vkinformer',
    bot_config_file => 'vk_informer_bot.rb.yml',
    bot_image       => 'elapeko/vkinformerbot',
    bot_token       => $vkinformer['tg']['token'],
    bot_database    => {
      'db_host'  => $vkinformer['db']['host'],
      'db_name'  => $vkinformer['db']['name'],
      'db_user'  => $vkinformer['db']['user'],
      'db_pass'  => $vkinformer['db']['pass'],
    }
  }
}
