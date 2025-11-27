class openvpn::requirements {
    # Installing Packages
    package { 'openvpn':
        ensure => installed,
    }

    # Remove unmanaged firewall rules
    resources { 'firewall':
        purge => true,
    }
}
