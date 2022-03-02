{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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
          permittedInsecurePackages = [ "electron-9.4.4" ];
        };
        overlays = [
          (self: super: {
            dwm = super.dwm.overrideAttrs (oldAttrs: rec {
              configFile = super.writeText "config.h"
                (builtins.readFile ./configs/dwm-config.h);
              postPatch = oldAttrs.postPatch or "" + ''

                echo 'Using own config file...'
                 cp ${configFile} config.def.h'';
              patches = [
                (super.fetchpatch {
                  url =
                    "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff";
                  sha256 =
                    "1lbzjr972s42x8b9j6jx82953jxjjd8qna66x5vywaibglw4pkq1";
                })
                (super.fetchpatch {
                  url =
                    "https://dwm.suckless.org/patches/systray/dwm-systray-6.3.diff";
                  sha256 =
                    "1plzfi5l8zwgr8zfjmzilpv43n248n4178j98qdbwpgb4r793mdj";
                })
              ];
            });
          })
        ];

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
    };
}
