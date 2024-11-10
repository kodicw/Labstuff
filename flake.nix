{
  description = "A template that shows all standard flake outputs";
  # unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";


  outputs = all@{ self,  nixpkgs, ... }:
    let
      namespace = "smart";
    in
    {

      # defaultPackage.x86_64-linux = c-hello.defaultPackage.x86_64-linux;

      nixosConfigurations.smart = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit namespace; };
        modules = [ ./config.nix ];
      };
    };
}
