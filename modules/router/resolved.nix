{ config, lib, namespace, ... }:
let
  cfg = config."${namespace}".router.resolved;
in
{
  options.${namespace}.router.resolved = {
    enable = lib.mkEnableOption "Enable LLDP";
  };

  config = lib.mkIf cfg.enable {
    services.resolved.enable = true;
  };
}
