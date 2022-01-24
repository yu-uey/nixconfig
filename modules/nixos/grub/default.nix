{ lib, config, ... }:
let
  cfg = config.my.bootloader.grub;
in
{
  options = {
    my.bootloader.grub = {
      enable = lib.mkEnableOption "Grub bootloader";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;
    };
  };
}
