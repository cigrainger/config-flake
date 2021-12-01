{ pkgs, ... }:

{
  xsession = {
    enable = true;

    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };

    profileExtra = ''
      eval $(${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=ssh,secrets)
      export SSH_AUTH_SOCK
    '';

    windowManager.bspwm = {
      enable = true;
      extraConfig = ''
        pgrep -x sxhkd > /dev/null || sxhkd &
        picom &
        polybar top &
        feh --bg-center ~/Pictures/wallpaper/dracula-pro/desktop-5120x2880.png

        bspc monitor -d I II III IV V VI VII VIII IX X

        bspc config border_width         2
        bspc config window_gap          12

        bspc config split_ratio          0.52
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true

        bspc config normal_border_color "#44475a"
        bspc config active_border_color "#bd93f9"
        bspc config focused_border_color "#ff79c6"
        bspc config presel_feedback_color "#6272a4"
        bspc config active_border_color "#6272a4"
        bspc config focused_border_color "#8be9fd"
      '';
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "Overpass Regular";
      size = 11;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

  xresources.extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "xresources";
    rev = "49765e34adeebca381db1c3e5516b856ff149c93";
    sha256 = "PoYRTnmMN6O7wVTHlvDRvBJSmrhPeH2gaiJwAaNLrRM=";
  } + "/Xresources");
}
