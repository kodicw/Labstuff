{ config, lib, namespace, ... }:
let
  cfg = config."${namespace}".router.firewall;
in
{
  options.${namespace}.router.firewall = {
    enable = lib.mkEnableOption "Enable LLDP";
    dhcp = lib.mkEnableOption "Enable DHCP";
    nat = lib.mkEnableOption "Enable NAT";
    #TODO: Make options for network manager interfaces
  };

  config = lib.mkIf cfg.enable {
    networking = {
      useNetworkd = true;
      useDHCP = cfg.dhcp;
      # No local firewall.
      nat.enable = cfg.nat;
      firewall.enable = lib.mkForce false;
      networkmanager.enable = true;
      networkmanager.unmanaged = [ "eno2" "eno3" "eno4" "br-lan" ];
      nftables = {
        enable = true;
        ruleset = ''
          table inet filter {
            chain input {
              type filter hook input priority 0; policy drop;

              iifname { "br-lan" } accept comment "Allow local network to access the router"
              iifname "wan" ct state { established, related } accept comment "Allow established traffic"
              iifname "wan" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
              iifname "wan" counter drop comment "Drop all other unsolicited traffic from wan"
              iifname "wlp0s21u2" ct state { established, related } accept comment "Allow established traffic"
              iifname "wlp0s21u2" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
              iifname "wlp0s21u2" counter drop comment "Drop all other unsolicited traffic from wan"
              iifname "eno1" ct state { established, related } accept comment "Allow established traffic"
              iifname "eno1" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
              iifname "eno1" counter drop comment "Drop all other unsolicited traffic from wan"
              iifname "lo" accept comment "Accept everything from loopback interface"
              tcp dport 9090 accept

            }
            chain forward {
              type filter hook forward priority filter; policy drop;

              iifname { "br-lan" } oifname { "wan" } accept comment "Allow trusted LAN to WAN"
              iifname { "wan" } oifname { "br-lan" } ct state { established, related } accept comment "Allow established back to LANs"
            }
          }

          table ip nat {
            chain postrouting {
              type nat hook postrouting priority 100; policy accept;
              oifname "wan" masquerade
              oifname "wlp0s21u2" masquerade
            }
          }
        '';
      };
    };

  };
}
