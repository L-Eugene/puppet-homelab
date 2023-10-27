class profile::leetcode_database {
  $leetcodedb = lookup('leetcodedb')

  mysql::db { 'leetcode':
    user     => $leetcodedb['user'],
    password => $leetcodedb['pass'],
    host     => '%',
    grant    => 'ALL',
  }
}
