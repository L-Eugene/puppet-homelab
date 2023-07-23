class profile::gnucash_database {
  $gnucash_users = lookup('gnucash_users')

  mysql::db { 'gnucash':
    user     => $gnucash_users[0]['username'],
    password => $gnucash_users[0]['password'],
    host     => '%',
    grant    => $gnucash_users[0]['grant'],

    # TODO: restore data from backup unless database exists
    sql            => ['/backup/epam-nb/gnucash-latest.sql.bz2'],
    import_cat_cmd => 'bzcat',
    enforce_sql    => false,
  }

  file { '/root/gnucash-backup.sh':
    content => "#!/bin/bash
      date=$(date +"%Y-%m-%d")
      mysqldump gnucash --no-tablespaces | bzip2 /tmp/gnucash-$date.sql.bz2
      cp /tmp/gnucash-$date.sql.bz2 /backup/homelab/gnucash-$date.sql.bz2
      mv /tmp/gnucash-$date.sql.bz2 /backup/homelab/gnucash-latest.sql.bz2
      ",
    mode    => '0755',
    owner   => 'root',
  }

  cron { 'backup-gnucash-db':
    command => '/root/gnucash-backup.sh',
    user    => 'root',
    hour    => 3,
    minute  => 0,
  }
}
