{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "porthos";

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = false;
    interfaces.enp5s0.useDHCP = true;
    interfaces.enp6s0.useDHCP = true;
    interfaces.wlp7s0.useDHCP = true;
  };

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

  environment.systemPackages = with pkgs; [ neovim git ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };
    xserver.videoDrivers = [ "nvidia" ];
  };

  programs.mosh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware.opengl.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
