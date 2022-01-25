{ lib, config, options, pkgs, ... }:
let
  cfg = config.my.users.yu;
in
{
  options = {
    my.users.yu = {
      enable = lib.mkEnableOption "user yu";
      home = lib.mkOption {
        type = options.home-manager.users.type.nestedTypes.elemType;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.yu = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "";
      shell = pkgs.bashInteractive;
    };
    my.users.yu.home = {
      programs.bash.enable = true;
      programs.vim.enable = true;
      home.sessionVariables.EDITOR = "vim";
    };
    home-manager.users.yu = lib.mkAliasDefinitions (options.my.users.yu.home);
  };
}
