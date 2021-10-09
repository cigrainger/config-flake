{ config, lib, pkgs, ... }:

let mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      fonts = [ "Overpass, FontAwesome 5" ];

      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";

        # Focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";

        # Move
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
      };

      bars = [ ];
    };
  };
}
