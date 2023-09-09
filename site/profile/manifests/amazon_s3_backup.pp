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

  file { '/root/gnucash-backup.sh':
    ensure => absent,
  }

  file { '/root/database-backup.sh':
    content => "#!/bin/bash
      date=\$(date +'%Y-%m-%d')
      mysqldump \$1 --no-tablespaces | bzip2 >/tmp/\$1-\$date.sql.bz2
      cp /tmp/\$1-\$date.sql.bz2 /backup/homelab/\$1-\$date.sql.bz2
      mv /tmp/\$1-\$date.sql.bz2 /backup/homelab/\$1-latest.sql.bz2
      ",
    mode    => '0755',
    owner   => 'root',
  }
}
