{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hardware = {
    nvidia.modesetting.enable = true;
    bluetooth.enable = true;
    video.hidpi.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = { trusted-users = [ "root" "chris" ]; };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Australia/Melbourne";

  networking = {
    hostName = "athos";
    useDHCP = false;
    interfaces.enp59s0.useDHCP = true;
    interfaces.enp60s0.useDHCP = true;
    interfaces.wlp58s0.useDHCP = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };

  security.rtkit.enable = true;

  users = {
    mutableUsers = false;
    users.chris = {
      isNormalUser = true;
      home = "/home/chris";
      description = "Christopher Grainger";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
      hashedPassword =
        "$6$RkxvMra2G8J0$RDJzuC2A9gd3xybyVIqPf2WAgY.ptEmXggKd5HSC7YfXuOb84yfdlIkDKTdEgCod1.zhXFUqwitisr8./v9ZI.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJghIJnlaP9mmCsjd7P/Ea4msZk+/tjMAvjyg06q6PJC chris@amplified.ai"
      ];
    };
  };

  environment = {
    etc."elixir-ls/language_server.sh".source =
      "${pkgs.elixir_ls}/lib/language_server.sh";

    systemPackages = with pkgs; [ neovim git ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    nerdfonts
    google-fonts
  ];

  # Enable the OpenSSH daemon.
  services = {

    cron = {
      enable = true;
      systemCronJobs = [
        "*/0 11 * * * bash -c 'cd \"$(navi info cheats-path)/<user>__<repo>\" && git pull -q origin master'"
      ];
    };

    redis.servers = { "" = { enable = true; }; };

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
      ];
    };

    fwupd = { enable = true; };

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    xserver = {
      enable = true;
      dpi = 144;
      videoDrivers = [ "nvidia" ];
      displayManager.gdm = {
        enable = true;
        wayland = false;
      };
      desktopManager.gnome.enable = true;
    };

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    gnome.gnome-keyring.enable = true;
    picom = {
      enable = true;
      backend = "glx";
      vSync = true;
    };
  };

  programs = {
    dconf.enable = true;
    mosh.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
