class openvpn (
    String $server_name = "server",
    Hash $server_config = {},
    Hash $ccd_options = {}
) {
    $configuration = {
        'port' => 1194,
        'proto' => "udp",
        'dev' => "tun",
        'topology' => "subnet",
        'server' => "10.0.0.0 255.255.255.0",
        'user' => 'nobody',
        'group' => 'nogroup',
        'status' => "openvpn-$server_name-status.log",
        'log-append' => '/var/log/openvpn.log',
        'verb' => 4
    } + $server_config

    # Installing Packages
    package { 'openvpn':
        ensure => installed,
    }

    # Creating server configuration file
    file {"/etc/openvpn/${server_name}.conf":
        ensure => file,
        content => epp('openvpn/configuration.epp', { 'config' => $configuration })
    }

    # Creating ccd dir and configurations if needed
    if $server_config.has_key('client-config-dir') {
        file {$server_config['client-config-dir']:
            ensure => directory
        }
    }

    if $ccd_options.size > 0 {
        $ccd_options.each |$filename, $config| {
            file {"${server_config['client-config-dir']}/${filename}":
                ensure => file,
                content => epp('openvpn/configuration.epp', { 'config' => $config })
            }
        }
    }
}