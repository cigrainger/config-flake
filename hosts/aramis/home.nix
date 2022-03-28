{ pkgs, config, ... }:

{
  imports = [ ../common/home.nix ../../home/firefox.nix ];

  home.packages = with pkgs; [
    _1password-gui
    authy
    brave
    calibre
    discord
    element-desktop
    electron
    filezilla
    gnome.gnome-tweaks
    libreoffice
    mpv
    postman
    signal-desktop
    slack
    tartube-yt-dlp
    transmission-gtk
    yubioath-desktop
    yt-dlp
    zotero
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };

  programs = {
    kitty = {
      enable = true;
      font = {
        name = "MonoLisa";
        size = 10;
      };
      theme = "Dracula";
    };
  };

  services = {
    xcape = {
      enable = true;
      mapExpression = { "#66" = "Escape"; };
      timeout = 200;
    };
  };
}
