{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware/master;
    lanzaboote = {
      url = github:nix-community/lanzaboote/v1.2.0;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      defaultModules = [
        ({ lib, pkgs, ... }: {
          nix = {
            extraOptions = "experimental-features = nix-command flakes";
            registry.nixpkgs.flake = nixpkgs;
          };
          system.configurationRevision = lib.mkIf (self ? rev) self.rev;
          environment.systemPackages = [ pkgs.git ];
        })
      ];
      
      importHost = path:
        let
          name = nixpkgs.lib.removeSuffix ".nix" (builtins.baseNameOf path);
          config = import path inputs;
        in
        {
          inherit name;
          value = nixpkgs.lib.nixosSystem {
            inherit (config) system;
            modules = builtins.concatLists [
              defaultModules
              config.modules
              [{ networking.hostName = nixpkgs.lib.mkDefault name; }]
            ];
          };
        };
    in
    {
      nixosConfigurations =
        let
          hostsPath = ./hosts;
        in
        nixpkgs.lib.mapAttrs'
          (path: _: importHost (hostsPath + "/${path}"))
          (builtins.readDir hostsPath);
    };
}
