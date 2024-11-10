{ config, lib, namespace, ... }:
let
  cfg = config."${namespace}".router.lldpd;
in
{
  options.${namespace}.router.lldpd = {
    enable = lib.mkEnableOption "Enable LLDP";
  };

  config = lib.mkIf cfg.enable {
    services.lldpd.enable = true;
  };
}
