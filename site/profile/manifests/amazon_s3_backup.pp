class profile::amazon_s3_backup {
  package { 'fuse':
    ensure => installed,
  }

  $aws_creds = lookup('aws_s3_backup')
  class { 'amazon_s3':
    aws_access_key     => $aws_creds['aws_access_key'],
    secret_access_key  => $aws_creds['secret_access_key'],
    use_system_package => true,
  }

  amazon_s3::s3_mount { 'elapeko-backup':
    mount_point => '/backup',
  }  
}
