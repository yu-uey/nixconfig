{ config, lib, pkgs, ... }:
let
  icon = pkgs.fetchurl {
    url = "https://play.geforcenow.com/mall/assets/icons/GFN-Logo-180.png";
    sha256 = "sha256-8Q+aG7mLVlBOXYu/o17hx/uZqzmmR/7tyqimXQlohto=";
  };
  desktopItem = pkgs.makeDesktopItem {
    name = "geforcenow";
    desktopName = "GeForce Now";
    exec = "${pkgs.chromium}/bin/chromium --kiosk https://play.geforcenow.com";
    icon = icon;
  };
  cfg = config.programs.geforcenow;
in {
  options.programs.geforcenow = {
    enable = lib.mkEnableOption "GeForce Now";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ desktopItem ];
  };
}