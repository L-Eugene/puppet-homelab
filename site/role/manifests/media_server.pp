# Media server role that combines timezone, Docker Compose, and torrent bot functionality
class role::media_server {
  class { 'profile::timezone':
    timezone => 'Europe/Sofia',
  }
  include profile::docker_compose
  include profile::torrentbot
}
