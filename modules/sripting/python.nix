{ config, lib, namespace, pkgs, ... }:
let
  cfg = config."${namespace}".scripting.python;
in
{
  options.${namespace}.scripting.python = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (python311.withPackages (ps: with ps; [
        pandas
        selenium
      ]))
    ];
  };
}
