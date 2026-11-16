{ config, lib, pkgs, ... }:
let
  cfg = config.my.secureboot;
in {
  options.my.secureboot = {
    enable = lib.mkEnableOption "Secureboot (Lanzaboote)";
    pkiBundle = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/sbctl";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sbctl ];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = cfg.pkiBundle;
    };
  };
}
