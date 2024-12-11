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
  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab
    epiphany
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-weather
    pkgs.gnome-connections
    simple-scan
    geary
    seahorse
  ];

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
    "steam"
    "steam-original"
    "steam-run"
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    tree
    discord
    gimp
    vlc
    abiword
    foot
    zotero
    imagemagick
    gnome.dconf-editor
    gnome.gnome-tweaks
  ];

  programs.steam.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "org.codeberg.dnkl.foot.desktop" ];
    };
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };

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

