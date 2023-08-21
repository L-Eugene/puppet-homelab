class profile::vkinformer_database {
  $vkinformer_user = lookup('vkinformer_user')

  mysql::db { 'vkinformer':
    user     => $vkinformer_user['username'],
    password => $vkinformer_user['password'],
    host     => '%',
    grant    => $vkinformer_user['grant'],

    # TODO: restore data from backup unless database exists
    #sql            => ['/backup/homelab/vkinformer-latest.sql.bz2'],
    #import_cat_cmd => 'bzcat',
    #enforce_sql    => false,
  }

  cron { 'backup-gnucash-db':
    command => '/root/database-backup.sh vkinformer',
    user    => 'root',
    hour    => 3,
    minute  => 5,
  }
}
