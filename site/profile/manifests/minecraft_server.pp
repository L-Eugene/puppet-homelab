# This class sets up a Minecraft server using Docker and systemd.
#
# It creates the necessary directory structure, generates a Docker Compose
# file for the Minecraft server, and manages the server as a systemd service.
class profile::minecraft_server {
  file { '/opt/minecraft':
    ensure => directory,
  }

  file { '/opt/minecraft/docker-compose.yml':
    ensure  => file,
    require => File['/opt/minecraft'],
    notify  => Service['minecraft.service'],
    content => @("EOF")
    version: '3'
    services:
      mc:
        image: itzg/minecraft-server
        environment:
          EULA: "true"
          TYPE: "FABRIC"
          PLUGINS: |
            https://cdn.modrinth.com/data/P7dR8mSH/versions/rYSz5dRU/fabric-api-0.119.6%2B1.21.5.jar
            https://cdn.modrinth.com/data/9eGKb6K1/versions/8NDcr1mc/voicechat-fabric-1.21.5-2.5.28.jar
        ports:
          - "25565:25565"
          - "24454:24454/udp"
          - "19132:19132/udp"
        volumes:
          - ./data:/data
        restart: unless-stopped

    |-EOF
  }

  systemd::manage_unit { 'minecraft.service':
    unit_entry    => {
      'Description' => 'Minecraft server',
      'PartOf'      => 'docker.service',
      'After'       => 'docker.service',
    },
    service_entry => {
      'Type'             => 'oneshot',
      'RemainAfterExit'  => true,
      'WorkingDirectory' => '/opt/minecraft/',
      'ExecStart'        => 'docker-compose up -d --remove-orphans',
      'ExecStop'         => 'docker-compose down',
    },
    install_entry => {
      'WantedBy' => 'multi-user.target',
    },
    enable        => true,
    active        => true,
  }
}
