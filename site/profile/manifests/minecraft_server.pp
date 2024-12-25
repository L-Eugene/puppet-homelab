# This class sets up a Minecraft server using Docker and systemd.
#
# It creates the necessary directory structure, generates a Docker Compose
# file for the Minecraft server, and manages the server as a systemd service.
class profile::minecraft_server {
  file { '/opt/minecraft':
    ensure => directory,
  }

  file { "/opt/${$name}/docker-compose.yml":
    ensure  => file,
    content => @("EOF")
      version: '3'
      services:
        mc:
          image: itzg/minecraft-server
          environment:
            EULA: "true"
            TYPE: "FABRIC"
            PLUGINS: |
              https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/fabric
              https://modrinth.com/project/bWrNNfkb/version/jb3lzved
              https://cdn.modrinth.com/data/P7dR8mSH/versions/15ijyoD6/fabric-api-0.113.0%2B1.21.4.jar
          ports:
            - "25565:25565"
            - "19132:19132/udp"
          volumes:
            - ./data:/data
          restart: unless-stopped
    EOF
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
