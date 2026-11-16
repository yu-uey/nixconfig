{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:nixos/nixos-hardware/master;
    lanzaboote = {
      url = github:nix-community/lanzaboote/v1.2.0;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.sl3 = nixpkgs.lib.nixosSystem (import ./hosts/sl3 inputs );
  };
}
