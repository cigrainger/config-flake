{ pkgs, ... }:

{
  programs.gnome-terminal = {
    enable = true;
    profile.chris = {
      allowBold = true;
      audibleBell = false;
      colors = {
        foregroundColor = "#F8F8F2";
        backgroundColor = "#282A36";
        boldColor = "#6E46A4";
        palette = [
          "#262626"
          "#E356A7"
          "#42E66C"
          "#E4F34A"
          "#9B6BDF"
          "#E64747"
          "#75D7EC"
          "#EFA554"
          "#7A7A7A"
          "#FF79C6"
          "#50FA7B"
          "#F1FA8C"
          "#BD93F9"
          "#FF5555"
          "#8BE9FD"
          "#FFB86C"
        ];
      };
      default = true;
      font = "JetBrainsMono Nerd Font Mono 12";
      visibleName = "chris";
    };
  };
}
