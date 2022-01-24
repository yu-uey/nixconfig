{ lib, config, pkgs, ... }:
let
  cfg = config.my.device.backlight;
in
{
  options = {
    my.device.backlight = {
      enable = lib.mkEnableOption "backlight control";
      buttons = {
        enable = lib.mkEnableOption "brightness button bindings";
        step = lib.mkOption {
          type = lib.types.int;
          description = "value to change brightness by";
          default = 5;
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.light.enable = true;
    services.acpid = lib.mkIf cfg.buttons.enable {
      enable = true;
      handlers =
        let
          step = toString cfg.buttons.step;
        in
        {
          "bl_u" = {
            event = "video/brightnessup";
            action = "${pkgs.light}/bin/light -A ${step}";
          };
          "bl_d" = {
            event = "video/brightnessdown";
            action = "${pkgs.light}/bin/light -U ${step}";
          };
        };
    };
  };
}
