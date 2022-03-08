{ config, pkgs, ... }:

{
  hardware = {
    bluetooth.enable = true;
    video.hidpi.enable = true;
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

  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "*/0 11 * * * bash -c 'cd \"$(navi info cheats-path)/<user>__<repo>\" && git pull -q origin master'"
      ];
    };

    fwupd = { enable = true; };

    openssh = {
      enable = true;
      passwordAuthentication = false;
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

    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = false;
        };
      };
      desktopManager.gnome.enable = true;
    };

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    picom = { enable = true; };
  };

  programs = {
    dconf.enable = true;
    mosh.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

}
