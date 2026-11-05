{
  description = "Lenovo ThinkBook NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	nixpkgs-opencode = {
	  url = "github:NixOS/nixpkgs/31ecbaca1bdefa45dffc409f0250bd8039ea0010";
	};
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, solaar, ... }:

  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations.yoga14 = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs nixpkgs-unstable;
      };

      modules = [
        ./configuration.nix
        ./hosts/yoga14.nix
		solaar.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";
	      home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.pegion = import ./yoga14-pegion-home.nix;
        }
      ];
    };
  };
}
