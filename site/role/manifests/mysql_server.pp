class role::mysql_server {
  include profile::mysql_server
  include profile::amazon_s3_backup
  include profile::gnucash_database
}
