{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/nordvpn.nix
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nordvpn = pkgs.callPackage ./pkgs/nordvpn.nix { };
  };

  services.nordvpn.enable = true;
  networking.firewall.checkReversePath = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.thermald.enable = true;

  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.firefox.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      rime
      mozc
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "nordvpn"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    tmux
    curl
    tree
    vscodium
    gnome.gnome-tweaks
    discord
    gimp
    vlc
  ];

  users.mutableUsers = false;
  users.users.yu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nordvpn" ];
    password = "123";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

 system.stateVersion = "23.11";
}

