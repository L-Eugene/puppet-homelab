class profile::vkinformerbot {
  $vkinformer_user = lookup('vkinformer_user')
  $vkinformer = lookup('vk_informer')

  class { 'telegram_bot':
    name            => 'vkinformer',
    bot_config_file => 'vk_informer_bot.rb.yml',
    bot_image       => 'elapeko/vkinformerbot',
    bot_token       => $vkinformer['tg']['token'],
    bot_database    => {
      'db_host'  => $vkinformer['db']['db_host'],
      'db_name'  => $vkinformer['db']['db_name'],
      'db_user'  => $vkinformer_user['username'],
      'db_pass'  => $vkinformer_user['password'],
    }
  }
}
