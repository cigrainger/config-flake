{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "BlexMono Nerd Font Mono 12";
#    theme = ../configs/rofi/dracula.rasi;
  };
}
