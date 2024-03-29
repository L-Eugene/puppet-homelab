class profile::vkinformer_database {
  $vkinformer = lookup('vk_informer')

  mysql::db { 'vkinformer':
    user     => $vkinformer['db']['user'],
    password => $vkinformer['db']['pass'],
    host     => '%',
    grant    => 'ALL',

    # TODO: restore data from backup unless database exists
    #sql            => ['/backup/homelab/vkinformer-latest.sql.bz2'],
    #import_cat_cmd => 'bzcat',
    #enforce_sql    => false,
  }

  cron { 'backup-vkinformer-db':
    command => '/root/database-backup.sh vkinformer',
    user    => 'root',
    hour    => 3,
    minute  => 5,
  }
}
