class role::mysql_server {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::ssh_root_auth
  include profile::mysql_server
  include profile::amazon_s3_backup
  include profile::gnucash_database
  include profile::vkinformer_database
  include profile::leetcode_database
}
