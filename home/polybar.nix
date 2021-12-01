{ pkgs, ... }:

{
  xdg.configFile."polybar/scripts" = {
    source = ../configs/polybar;
    recursive = true;
    executable = true;
  };

  services.polybar = {
    enable = true;

    settings = {
      "bar/top" = {
        monitor = "\${env:MONITOR:DP-0}";
        width = "100%";
        height = "1%";
        radius = 0;
        modules-right = "date";
        modules-left = "bspwm";
        font-0 = "Overpass:size=12;0";
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };

      "module/bspwm" = {
        type = "internal/bspwm";
        ws-icon-0 = "code;♚";
        ws-icon-1 = "office;♛";
        ws-icon-2 = "graphics;♜";
        ws-icon-3 = "mail;♝";
        ws-icon-4 = "web;♞";
        ws-icon-default = "♟";
        format = "<label-state> <label-mode>";
      };

      "module/pipewire" = {
        type = "custom/script";
        label = "%output%";
        label-font = 2;
        interval = "2.0";
        exec = "~/.config/polybar/scripts/pipewire.sh";
        click-right = "exec pavucontrol &";
        click-left = "~/.config/polybar/scripts/pipewire.sh mute &";
        scroll-up = "~/.config/polybar/scripts/pipewire.sh up &";
        scroll-down = "~/.config/polybar/scrupts/pipewire.sh down &";
      };
    };

    package = pkgs.polybar.override { githubSupport = true; };
    script = "polybar top &";
  };
}
