class role::mysql_server {
  include profile::lab_timezone
  include profile::mysql_server
  include profile::amazon_s3_backup
  include profile::gnucash_database
  include profile::vkinformer_database
  include profile::leetcode_database
}
