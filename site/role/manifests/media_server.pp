# Media server role that combines timezone, Docker Compose, and torrent bot functionality
class role::media_server {
  include profile::lab_timezone
  include profile::docker_compose
  include profile::torrentbot
}
