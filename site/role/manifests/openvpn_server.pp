# @summary Compose profiles for OpenVPN server hosts.
class role::openvpn_server{
  include profile::puppet_agent_locale
  include profile::vpn_private
  include profile::vpn_static
  include profile::vpn_academy
}
