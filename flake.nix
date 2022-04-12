{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nur, helix, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ "electron-9.4.4" ];
        };
        overlays = [
          (_: _: { helix = helix.packages.x86_64-linux.helix; })
          nur.overlay
        ];
      };
    in
    {
      nixosConfigurations.athos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs = { inherit pkgs; }; }
          ./hosts/athos/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.aramis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs = { inherit pkgs; }; }
          ./hosts/aramis/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
