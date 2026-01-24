class profile::gnucash_database {
  $gnucash_users = lookup('gnucash_users')

  $databases = ['gnucash', 'gnucash_euro', 'gnucash_chgk']

  $databases.each |$db_name| {
    mysql::db { $db_name:
      user           => $gnucash_users[0]['username'],
      password       => $gnucash_users[0]['password'],
      host           => '%',
      grant          => $gnucash_users[0]['grant'],

      sql            => ["/backup/homelab/${db_name}-latest.sql.bz2"],
      import_cat_cmd => 'bzcat',
      enforce_sql    => false,
    }

    cron { "backup-${db_name}-db":
      command => "/root/database-backup.sh ${db_name}",
      user    => 'root',
      hour    => 3,
      minute  => 0,
    }
  }

  $gnucash_users.each |$user| {
    if $user['username'] == $gnucash_users[0]['username'] {
      # Skipping the first user as it's already created and granted
      next()
    }

    mysql_user { "${$user['username']}@%":
      password_hash => mysql::password($user['password']),
    }

    $databases.each |$db_name| {
      mysql_grant { "${$user['username']}@%/${db_name}.*":
        user       => "${$user['username']}@%",
        privileges => $user['grant'],
        table      => "${db_name}.*",
      }

      # Even for readonly accounts GnuCash is trying to do some write operations
      # https://bugs.gnucash.org/show_bug.cgi?id=645216
      mysql_grant { "${$user['username']}@%/${db_name}.numtest":
        user       => "${$user['username']}@%",
        privileges => 'ALL',
        table      => "${db_name}.numtest",
      }
    }
  }

}
