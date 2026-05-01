## @summary Manage an OpenVPN server instance and optional CCD entries.
#
# @param server_name
#   Name of the OpenVPN server instance (used for config and systemd unit naming).
# @param server_config
#   Hash of OpenVPN server configuration directives.
# @param ccd_options
#   Hash of client-specific CCD filenames and their directive hashes.
#   Each CCD hash can include `state` with values `present` or `absent`.
#   When omitted, `state` defaults to `present`.
define openvpn::server (
    String $server_name = $name,
    Hash $server_config = {},
    Hash $ccd_options = {}
) {
    $server_config_file = "/etc/openvpn/${server_name}.conf"

    $configuration = {
        'port' => 1194,
        'proto' => 'udp',
        'dev' => 'tun',
        'topology' => 'subnet',
        'user' => 'nobody',
        'group' => 'nogroup',
        'status' => "openvpn-${server_name}-status.log",
        'log-append' => '/var/log/openvpn.log',
        'verb' => 4
    } + $server_config

    # Creating server configuration file
    file {$server_config_file:
        ensure  => file,
        content => epp('openvpn/configuration.epp', { 'config' => $configuration })
    }

    # Creating ccd dir and configurations if needed
    if 'client-config-dir' in $server_config {
        file {$server_config['client-config-dir']:
            ensure => directory
        }
    }

    if $ccd_options.size > 0 {
        $ccd_options.each |$filename, $config| {
            if 'state' in $config {
                $ccd_state = $config['state']
            } else {
                $ccd_state = 'present'
            }

            if !($ccd_state in ['present', 'absent']) {
                fail("Invalid state for ccd option '${filename}': '${ccd_state}'. Expected 'present' or 'absent'.")
            }

            $ccd_config = $config.filter |$key, $_value| {
                $key != 'state'
            }

            if $ccd_state == 'present' {
                file {"${server_config['client-config-dir']}/${filename}":
                    ensure  => file,
                    content => epp('openvpn/configuration.epp', { 'config' => $ccd_config })
                }
            } else {
                file {"${server_config['client-config-dir']}/${filename}":
                    ensure => absent,
                }
            }
        }
    }

    service { "openvpn@${server_name}.service":
        ensure    => running,
        provider  => systemd,
        enable    => true,
        subscribe => File[$server_config_file],
    }
}
