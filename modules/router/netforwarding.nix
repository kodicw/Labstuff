{ config, lib, namespace, ... }:
let
  cfg = config."${namespace}".router.kernal.forwarding;
in
{
  options.${namespace}.router.kernal.forwarding = {
    enable = lib.mkEnableOption "Enable LLDP";
    ipv4 = lib.mkEnableOption "Enable IPv4 forwarding (default: true)";
    ipv6 = lib.mkEnableOption "Enable IPv6 forwarding (default: false) ";
  };

  config = lib.mkIf cfg.enable {
    boot.kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = cfg.ipv4;
        "net.ipv6.conf.all.forwarding" = cfg.ipv6;
      };
    };
  };
}
