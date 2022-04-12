{ config, pkgs, ... }:

{
  hardware = {
    bluetooth.enable = true;
    video.hidpi.enable = true;
    opengl.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = { trusted-users = [ "root" "chris" ]; };

  };

  nixpkgs.config = {
    allowUnfree = true;
    enableRedistributableFirmware = true;
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
    firewall.extraCommands = ''
      ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
    '';
  };

  security.rtkit.enable = true;

  users = {
    extraGroups.vboxusers.members = [ "chris" ];
    mutableUsers = false;
    users.chris = {
      isNormalUser = true;
      home = "/home/chris";
      description = "Christopher Grainger";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.fish;
      hashedPassword =
        "$6$RkxvMra2G8J0$RDJzuC2A9gd3xybyVIqPf2WAgY.ptEmXggKd5HSC7YfXuOb84yfdlIkDKTdEgCod1.zhXFUqwitisr8./v9ZI.";
    };
  };

  environment = {
    etc."elixir-ls/language_server.sh".source =
      "${pkgs.elixir_ls}/lib/language_server.sh";

    systemPackages = with pkgs; [ helix git ];
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

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    picom = { enable = true; };
    nfs.server.enable = true;
  };

  programs = {
    dconf.enable = true;
    mosh.enable = true;
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation = {
    virtualbox.host.enable = true;
    podman = {
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
