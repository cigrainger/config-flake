{ config, pkgs, lib, ... }:

{
  imports = [ ../common/configuration.nix ./hardware-configuration.nix ];

  hardware = {
    trackpoint = {
      enable = true;
      device = "TPPS/2 Elan Trackpoint";
      emulateWheel = true;
    };
    pulseaudio.enable = false;
  };

  networking.hostName = "aramis";

  services = {
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      desktopManager.gnome.enable = true;
      videoDrivers = [ "modesetting" ];
      useGlamor = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };


  environment = {
    systemPackages = with pkgs; [ alsa-tools ];
  };

  home-manager.users.chris = ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
