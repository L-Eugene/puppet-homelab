#
# Demonstrates simple case for using module.
#
# === Copyright
#
# GPL-3.0+
#
class {'amazon_s3':
  aws_access_key    => 'ACCESS_KEY',
  secret_access_key => 'SECRET_KEY',
}
#amazon_s3::s3_mount{'s3_mount':
#  mount_point => '/mnt/s3_mount',
#  require     => Class['amazon_s3'],
#}
