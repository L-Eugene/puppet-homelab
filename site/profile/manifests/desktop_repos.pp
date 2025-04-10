class profile::desktop_repos {

  # Ensure the apt-transport-https package is installed
  package { 'apt-transport-https':
    ensure => installed,
  }

  apt::source { 'docker_repo':
    location      => 'https://download.docker.com/linux/ubuntu',
    release       => 'jammy',
    repos         => 'stable',
    architecture  => 'amd64',
    include       => {
      src => false,
    },
    key           => {
      id     => '9DC858229FC7DD38854AE2D88D81803C0EBFCD88',
      source => 'https://download.docker.com/linux/ubuntu/gpg',
    },
    notify_update => true,
  }
}
