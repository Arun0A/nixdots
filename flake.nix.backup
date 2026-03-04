{
  description = "Len-ThinkBook Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations.yoga14 = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
      ];
    };
    homeConfigurations = {
      pegion = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./yoga14-pegion-home.nix
      ];
    };
  };
  };
}
