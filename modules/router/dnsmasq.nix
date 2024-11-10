{ config, lib, namespace, ... }:
let
  cfg = config."${namespace}".router.dnsmasq;
in
{
  options.${namespace}.router.dnsmasq = {
    enable = lib.mkEnableOption "Enable LLDP";
  };

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      settings = {
        # upstream DNS servers
        server = [ "9.9.9.9" "8.8.8.8" "1.1.1.1" ];
        # sensible behaviours
        domain-needed = true;
        bogus-priv = false;
        no-resolv = true;

        # Cache dns queries.
        cache-size = 1000;

        dhcp-range = [ "br-lan,192.168.10.200,192.168.10.250,24h" ];
        interface = "br-lan";
        dhcp-host = "192.168.10.251";

        # local domains
        local = "/lan/";
        domain = "lan";
        expand-hosts = true;

        # don't use /etc/hosts as this would advertise surfer as localhost
        no-hosts = true;
        address = "/surfer.lan/192.168.10.251";
      };
    };

  };
}
