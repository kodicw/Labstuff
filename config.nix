{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware.nix
      ./modules
    ];

  smart = {
    router = {
      firewall.enable = true;
      dnsmasq.enable = true;
      lldpd.enable = true;
      kernal.forwarding.enable = true;
      resolved.enable = true;
      dnet.enable = true;
    };
    apps.network.tools.enable = true;
    scripting = {
      python.enable = true;
      vscode.enable = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  users.users.smart = {
    isNormalUser = true;
    description = "smart";
    extraGroups = [ 
      "networkmanager" 
      "wheel"
      "libvirtd"
      "tty"
      "dialout"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "smart";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  programs.firefox.enable = true;

  users.defaultUserShell = pkgs.nushell;
  security.sudo.wheelNeedsPassword = false;
  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    tmux
    fzf
    chromedriver
    carapace
    btop
    quickemu
    minicom
  ];
  system.stateVersion = "24.05"; # Did you read the comment?
}
