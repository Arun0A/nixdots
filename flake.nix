{
  description = "Lenovo ThinkBook NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations.yoga14 = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit nixpkgs-unstable;
      };

      modules = [
        ./configuration.nix
	home-manager.nixosModules.home-manager
      ];
    };

    homeConfigurations.pegion =
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./yoga14-pegion-home.nix
        ];
      };
  };
}
