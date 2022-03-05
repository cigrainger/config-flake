{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "electron-9.4.4" ];
        };
      };
    in {
      nixosConfigurations.athos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs = { inherit pkgs; };
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
      nixosConfigurations.aramis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs = {
              inherit pkgs;
              overlays = [ nur.overlay ];
            };
            environment.etc.nixpkgs.source = nixpkgs;
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
          }
          ./aramis-configuration.nix
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
