{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.nordvpn.enable = true;
  networking.firewall.checkReversePath = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my.secureboot = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  services.thermald.enable = true;

  networking.networkmanager.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  programs.firefox = {
    enable = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
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
    "discord-unwrapped"
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
    jq
    discord
    gimp
    vlc
    abiword
    foot
    # zotero # zotero uses an old, insecure firefox
    imagemagick
    ffmpeg
    pandoc
    transmission_4-gtk
    gnome-tweaks gnome-text-editor gnome-calculator gnome-characters gnome-console gnome-font-viewer gnome-logs gnome-system-monitor loupe nautilus papers showtime snapshot yelp
    cloudflare-warp
  ];

  services.cloudflare-warp.enable = true;
  networking.firewall.allowedUDPPorts = [ 2048 ];


  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk.pkgs.withPackages (epkgs: [
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

