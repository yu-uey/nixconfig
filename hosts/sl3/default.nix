{
  self,
  nixpkgs,
  nixos-hardware,
  lanzaboote,
  ...
}: {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.microsoft-surface-pro-intel
    lanzaboote.nixosModules.lanzaboote
    ./configuration.nix
    ../../modules/secureboot.nix
    ({ lib, pkgs, ... }: {
      nix.registry.nixpkgs.flake = nixpkgs;
      system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
    })
  ];
}
