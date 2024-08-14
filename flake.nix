{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-24.05;
    nixos-hardware.url = github:nixos/nixos-hardware/master;
    lanzaboote = {
      url = github:nix-community/lanzaboote/v0.4.1;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-hardware, lanzaboote }: {
    nixosConfigurations.sl3 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
      	lanzaboote.nixosModules.lanzaboote
        ./configuration.nix
        ({ lib, pkgs, ... }: {
          environment.systemPackages = [ pkgs.sbctl ];
          boot.loader.systemd-boot.enable = lib.mkForce false;
          boot.lanzaboote = {
            enable = true;
	          pkiBundle = /etc/secureboot;
          };
          nix.registry.nixpkgs.flake = nixpkgs;
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
      ];
    };
  };
}
