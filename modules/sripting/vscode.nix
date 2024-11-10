{ config, lib, namespace, pkgs, ... }:
let
  cfg = config."${namespace}".scripting.vscode;
in
{
  options.${namespace}.scripting.vscode = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          ms-python.python
          ms-vscode-remote.remote-ssh
        ];
      })
    ];
  };
}
