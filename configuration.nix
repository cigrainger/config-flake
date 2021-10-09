{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  hardware = {
    nvidia.modesetting.enable = true;
    pulseaudio.enable = false;
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
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
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
    # firewall.allowedTCPPorts = [ 8080 8888 ];
  };

  security.rtkit.enable = true;

  users = {
    mutableUsers = false;
    users.chris = {
      isNormalUser = true;
      home = "/home/chris";
      description = "Christopher Grainger";
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
      hashedPassword =
        "$6$RkxvMra2G8J0$RDJzuC2A9gd3xybyVIqPf2WAgY.ptEmXggKd5HSC7YfXuOb84yfdlIkDKTdEgCod1.zhXFUqwitisr8./v9ZI.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBFvWc7SliSI4iyOoKnv2bzWgYIireQytzj+GHQ8YiTV chris@amplified.ai"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtTNScri77nU/O9GooKdy7uaBHcTNVPTt+QT2f3wzn7N0HhLHfOQ9EpUATMPB2yyYnpftI8g9y5w6+GbUUlhlUzPC/9Ylu/T3R5YWj7z0as5yi44GRMY8dnuwgfxX1psH5yQR0TdeHxkPkKnUQQY9mJ4uM21ssaxf5RBDlKDATvN2RCsR3EzEV5OddMt1UtYv+Qh9PR+GYRMYmd1oa59a5Zjj3yQsi8AW+UGSMffY50SHKiRQoOA1MYWmbq0ZFMCpJRJFeE54DX3lXBEeO4xWGWIpF6gJtd/CZGYV9TR5NwW899L3vWkLuuDR8amfuiI7TmZRAgrxS14AG9U/KHQ7L++KQ24Xxq+SU4GZKZ72JXxiPrYp57JDQhN7vMlLoPzdsojPRn2ZK5oTKNiTdmOP+v0XoN8PUNKS+pI+FyWAWOULrgOnjh5BfTSSrNkobGuKTD9ahEjknpzo6ZsuOjN8Y0CTJFwgGK7s8GgASplYpRfRSlyygAaFlu8GsN9Df36ebaQdk6m+QJ5H0a+5J2f5My24A4DAs/rdrezmuU3TsfCBbDslGqHx2wUGggDnHT0kpiRMIUalXZqTN26ZfwKPDAnQ8PkaydTKGJRNsshDlOOD//lsTLxFHxwTp/Y/KpJ4h/Wyh0+b6zGbqXXlk1uskVxiGNJi+nC0VYBfgvFnamw=="
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [ neovim git ];
    gnome.excludePackages = with pkgs.gnome; [
      baobab
      cheese
      eog
      epiphany
      gedit
      simple-scan
      totem
      yelp
      geary
      gnome-maps
      gnome-music
    ];
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
    redis.enable = true;

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

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    xserver = {
      enable = true;

      desktopManager.gnome.enable = true;

      displayManager = {
        gdm = {
          enable = true;
          nvidiaWayland = true;
        };
      };

      videoDrivers = [ "nvidia" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  programs.mosh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
