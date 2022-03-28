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

  systemd.user.services.foo = {
    script = ''
      sudo hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  boot.initrd.kernelModules = [ "i915" ];

  environment = {
    systemPackages = with pkgs; [ alsa-tools ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    variables = {
      VDPAU_DRIVER =
        lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
