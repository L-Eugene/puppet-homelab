class role::bot_server {
  include profile::lab_timezone
  include profile::docker_compose
  include profile::vkinformerbot
}
