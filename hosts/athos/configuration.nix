{ config, pkgs, ... }:

{
  imports = [ ..common/configuration.nix ./hardware-configuration.nix ];

  hardware = {
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  networking.hostName = "athos";

  users.users.chris.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJghIJnlaP9mmCsjd7P/Ea4msZk+/tjMAvjyg06q6PJC chris@amplified.ai"
  ];

  # Enable the OpenSSH daemon.
  services = {
    xserver.videoDrivers = [ "nvidia" ];
    picom = {
      backend = "glx";
      vSync = true;
    };
  };

  programs = {
    dconf.enable = true;
    mosh.enable = true;
  };

  virtualisation.podman.enableNvidia = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
