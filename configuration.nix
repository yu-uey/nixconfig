{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/nordvpn.nix
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    nordvpn = pkgs.callPackage ./pkgs/nordvpn.nix { };
    cloudflare-warp = pkgs.callPackage ./cloudflare-warp.nix { };
  };
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     cloudflare-warp = prev.cloudflare-warp.overrideAttrs (old: {
  #       version = "2025.5.893.0";
  #       src = prev.fetchurl {
  #         url = "https://pkg.cloudflareclient.com/pool/jammy/main/c/cloudflare-warp/cloudflare-warp_2025.5.893.0_amd64.deb";
  #         hash = "sha256-1uke07OePug7eqjKL+CTRNBJkCm/7F33a4d1H/K9CaM=";
  #       };
  #     });
  #   })
  # ];

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

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

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
    "cloudflare-warp"
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
    ffmpeg
    pandoc
    transmission_4-gtk
    gnome.gnome-tweaks
    vscodium
    cloudflare-warp
  ];

  # services.cloudflare-warp.enable = true;
  systemd.packages = [ pkgs.cloudflare-warp ];
  systemd.services.warp-svc.wantedBy = [ "multi-user.target" ];
  networking.firewall.allowedUDPPorts = [ 2048 ];

  programs.steam.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "org.codeberg.dnkl.foot.desktop" ];
    };
  };

  services.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk.pkgs.withPackages (epkgs: [
      epkgs.vterm
      (epkgs.treesit-grammars.with-grammars (grammars: with grammars; [
        tree-sitter-nix
        tree-sitter-elisp
        tree-sitter-java
        tree-sitter-python
        tree-sitter-html
        tree-sitter-typescript
        tree-sitter-javascript
      ]))
    ]);
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

