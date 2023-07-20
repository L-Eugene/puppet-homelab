class profile::gnucash_database {
  mysql::db { 'gnucash':
    user     => $gnucash_users[0]['username'],
    password => $gnucash_users[0]['password'],
    host     => '%',
    grant    => $gnucash_users[0]['grant'],
    # TODO: restore data from backup unless database exists
    # sql => filename
    # enforce_sql => false
  }
}
