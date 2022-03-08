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
        overlays = [
          (_: _: { cider = pkgs.callPackage ./pkgs/cider.nix { }; })
          nur.overlay
        ];
      };
      common_config = {
        nixpkgs = { inherit pkgs; };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.chris = ./home.nix;
      };
    in {
      nixosConfigurations.athos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/athos/configuration.nix
          home-manager.nixosModules.home-manager
          common_config
        ];
      };
      nixosConfigurations.aramis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/aramis/configuration.nix
          home-manager.nixosModules.home-manager
          common_config
        ];
      };
    };
}
