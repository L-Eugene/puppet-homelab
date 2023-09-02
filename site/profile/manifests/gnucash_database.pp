class profile::gnucash_database {
  $gnucash_users = lookup('gnucash_users')

  mysql::db { 'gnucash':
    sql            => ['/backup/homelab/gnucash-latest.sql.bz2'],
    import_cat_cmd => 'bzcat',
    enforce_sql    => false,
  }

  $gnucash_users.each |$user| {
    mysql::db { 'gnucash':
      user     => $user['username'],
      password => $user['password'],
      host     => '%',
      grant    => $user['grant'],
    }
  }

  cron { 'backup-gnucash-db':
    command => '/root/database-backup.sh gnucash',
    user    => 'root',
    hour    => 3,
    minute  => 0,
  }
}
