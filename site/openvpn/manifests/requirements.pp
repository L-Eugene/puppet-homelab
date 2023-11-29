class openvpn::requirements {
    # Installing Packages
    package { 'openvpn':
        ensure => installed,
    }
}