{ config, lib, namespace, pkgs, ... }:
let
  cfg = config."${namespace}".apps.network.tools;
in
{
  options.${namespace}.apps.network.tools = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nmap
      ipmicfg
      ethtool
      tcpdump
      conntrack-tools
      wget
      netscanner
    ];
  };
}
