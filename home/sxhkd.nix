{ pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # terminal emulator
      "super + Return" = "alacritty";
      # program launcher
      "super + @space" = "rofi -show run -modi drun,ssh";
      # make sxhkd reload its configuration files
      "super + Escape" = "pkill -USR1 -x sxhkd";
      # quit/restart bspwm
      "super + alt + {q,r}" = "bspc {quit,wm -r}";
      # close and kill
      "super + {_,shift + }w" = "bspc node -{c,k}";
      # alternate between tiled and monocle layout
      "super + m" = "bspc desktop -l next";
      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" =
        "bspc node -{f,s} {west,south,north,east}";
      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {pref,next}.local";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
    };
  };
}
