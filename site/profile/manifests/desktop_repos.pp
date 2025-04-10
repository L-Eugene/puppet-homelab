class profile::desktop_repos {

  # Ensure the apt-transport-https package is installed
  package { 'apt-transport-https':
    ensure => installed,
  }

  apt { 'apt_repositories':
    before  => Apt::Key['deb_opera_com_repo_key'],
    sources => {
      'deb_opera_com_repo' => {
        location      => 'https://deb.opera.com/opera-stable/',
        release       => 'jammy',
        repos         => ['stable', 'non-free'],
        architecture  => 'amd64',
        include       => {
          src => false,
        },
        key           => {
          id     => '9701D4A1B4D92E261C8C66FE24A1004B1F11DCC9',
          source => 'https://deb.opera.com/archive.key',
        },
        notify_update => true,
      },
      'docker_repo'        => {
        location      => 'https://download.docker.com/linux/ubuntu',
        release       => 'jammy',
        repos         => ['stable'],
        architecture  => 'amd64',
        include       => {
          src => false,
        },
        key           => {
          id     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
          source => 'https://download.docker.com/linux/ubuntu/gpg',
        },
        notify_update => true,
      },
    },
  }
}
