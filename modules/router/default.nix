{ ... }: {
  imports = [
    ./netforwarding.nix
    ./lldp.nix
    ./resolved.nix
    ./dnet.nix
    ./dnsmasq.nix
    ./firewall.nix
  ];
}
