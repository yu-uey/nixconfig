{ lib, config, options, pkgs, ... }:
let
  cfg = config.my.users.yu;
in
{
  options = {
    my.users.yu = {
      enable = lib.mkEnableOption "user yu";
      home = lib.mkOption {
        type = lib.types.deferredModule;
        default = {};
      };
    };
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      users.users.yu = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        password = "";
        shell = pkgs.bashInteractive;
      };
    }
    (lib.optionalAttrs (options ? home-manager) {
      home-manager.users.yu = {
        imports = [ cfg.home ];
        programs.bash.enable = true;
        programs.vim.enable = true;
        home.sessionVariables.EDITOR = "vim";
      };
    })
  ]);
}
