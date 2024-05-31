{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs : 
  let
   
  system = "x86_64-linux";
  # pkgs = import nixpkgs {
  #   inherit system;

  #   config = {
  #     allowUnfree = true;
  # };

 in
{
    nixosConfigurations = {
      carbon = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
        };
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
  };
}
