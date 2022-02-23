{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };
    in {
      nixosConfigurations.athos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            environment.etc.nixpkgs.source = nixpkgs;
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
          }
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config = { allowUnfree = true; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.chris = ./home.nix;
          }
        ];
      };
    };
}
