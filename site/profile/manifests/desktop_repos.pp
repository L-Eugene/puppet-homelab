class profile::desktop_repos {

  # Ensure the apt-transport-https package is installed
  package { 'apt-transport-https':
    ensure => installed,
  }

  # Download the Puppet 7 release package to /opt
  file { '/opt/puppet7-release-jammy.deb':
    ensure => file,
    source => 'https://apt-puppetcore.puppet.com/public/puppet7-release-jammy.deb',
  }

  # Install the Puppet 7 release package from a URL
  package { 'puppet7-release':
    ensure   => installed,
    source   => '/opt/puppet7-release-jammy.deb',
    provider => 'dpkg',
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
