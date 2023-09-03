class profile::gnucash_database {
  $gnucash_users = lookup('gnucash_users')

  mysql::db { 'gnucash':
    user           => $gnucash_users[0]['username'],
    password       => $gnucash_users[0]['password'],
    host           => '%',
    grant          => $gnucash_users[0]['grant'],

    sql            => ['/backup/homelab/gnucash-latest.sql.bz2'],
    import_cat_cmd => 'bzcat',
    enforce_sql    => false,
  }

  $gnucash_users.each |$user| {
    if $user['username'] == $gnucash_users[0]['username'] {
      # Skipping the first user as it's already created and granted
      next()
    }

    mysql_user { "${$user['username']}@%":
      password_hash => mysql::password($user['password']),
    }

    mysql_grant { "${$user['username']}@%/gnucash.*":
      user       => "${$user['username']}@%",
      privileges => $user['grant'],
      table      => 'gnucash.*',
    }

    # Even for readonly accounts GnuCash is trying to do some write operations
    # https://bugs.gnucash.org/show_bug.cgi?id=645216
    mysql_grant { "${$user['username']}@%/gnucash.numtest":
      user       => "${$user['username']}@%",
      privileges => 'ALL',
      table      => 'gnucash.numtest',
    }
  }

  cron { 'backup-gnucash-db':
    command => '/root/database-backup.sh gnucash',
    user    => 'root',
    hour    => 3,
    minute  => 0,
  }
}
