{
  system = "x86_64-linux";
  modules = [

    ./hardware-configuration.nix

    ({ pkgs, ... }: {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      my.device.backlight = {
        enable = true;
        buttons = {
          enable = true;
          step = 10;
        };
      };

      networking.useDHCP = false;
      networking.networkmanager.enable = true;

      users.users.yu = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        password = "";
      };

      system.stateVersion = "21.11";
    })

  ];
}
