{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware/master;
    lanzaboote = {
      url = github:nix-community/lanzaboote/v1.2.0;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-hardware, lanzaboote }: {
    nixosConfigurations.sl3 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
        lanzaboote.nixosModules.lanzaboote
        ./hosts/sl3/configuration.nix
        ./modules/secureboot.nix
        ({ lib, pkgs, ... }: {
          nix.registry.nixpkgs.flake = nixpkgs;
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        })
      ];
    };
  };
}
