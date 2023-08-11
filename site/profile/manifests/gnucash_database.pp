class profile::gnucash_database {
  $gnucash_users = lookup('gnucash_users')

  mysql::db { 'gnucash':
    user     => $gnucash_users[0]['username'],
    password => $gnucash_users[0]['password'],
    host     => '%',
    grant    => $gnucash_users[0]['grant'],

    # TODO: restore data from backup unless database exists
    sql            => ['/backup/homelab/gnucash-latest.sql.bz2'],
    import_cat_cmd => 'bzcat',
    enforce_sql    => false,
  }

  cron { 'backup-gnucash-db':
    command => '/root/database-backup.sh gnucash',
    user    => 'root',
    hour    => 3,
    minute  => 0,
  }
}
