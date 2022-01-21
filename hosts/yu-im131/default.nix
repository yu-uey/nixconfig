{ home-manager, ... }: {
  system = "x86_64-linux";
  modules = [

    ./hardware-configuration.nix
    ../../modules/nixos/backlight
    ../../modules/nixos/pipewire

    home-manager.nixosModules.home-manager

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

      my.pipewire.enable = true;

      networking.useDHCP = false;
      networking.networkmanager.enable = true;

      users.users.yu = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        password = "";
      };

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      system.stateVersion = "21.11";
    })

  ];
}
