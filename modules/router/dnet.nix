{ config, lib, namespace, ... }:
let
  cfg = config."${namespace}".router.dnet;
in
{
  options.${namespace}.router.dnet = {
    enable = lib.mkEnableOption "enable dnet";
  };

  config = lib.mkIf cfg.enable {
    systemd.network = {
      wait-online.anyInterface = true;
      netdevs = {
        # Create the bridge interface
        "20-br-lan" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "br-lan";
          };
        };
      };
      networks = {
        "30-lan0" = {
          matchConfig.Name = "eno4";
          networkConfig = {
            Bridge = "br-lan";
            ConfigureWithoutCarrier = true;
          };
          linkConfig.RequiredForOnline = "enslaved";
        };
        # lan1 and lan2 look analogical
        "30-lan2" = {
          matchConfig.Name = "eno2";
          networkConfig = {
            Bridge = "br-lan";
            ConfigureWithoutCarrier = true;
          };
          linkConfig.RequiredForOnline = "enslaved";
        };
        "40-br-lan" = {
          matchConfig.Name = "br-lan";
          bridgeConfig = { };
          address = [
            "192.168.10.251/16"
          ];
          networkConfig = {
            ConfigureWithoutCarrier = true;
          };
        };
        "10-wan" = {
          matchConfig.Name = "eno3";
          networkConfig = {
            # start a DHCP Client for IPv4 Addressing/Routing
            DHCP = "ipv4";
            DNSOverTLS = true;
            DNSSEC = true;
            IPv6PrivacyExtensions = false;
            IPForward = true;
          };
          # make routing on this interface a dependency for network-online.target
          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
  };
}
