{ lib, config, pkgs, ... }:
let
  cfg = config.my.pipewire;
in
{
  options = {
    my.pipewire = {
      enable = lib.mkEnableOption "PipeWire";
    };
  };
  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    environment.systemPackages = [
      pkgs.alsa-utils
      pkgs.pulseaudio
    ];
  };
}
