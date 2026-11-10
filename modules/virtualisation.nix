{ config, lib, pkgs, ... }:
let
  cfg = config.my.virtualisation;
in
{
  options.my.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      onShutdown = "shutdown";
    };
    environment.systemPackages = [ pkgs.gnome.gnome-boxes ];
  };
}
