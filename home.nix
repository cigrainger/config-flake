{ pkgs, config, ... }:

{
  imports = [
    ./home/alacritty.nix
    ./home/bspwm.nix
    ./home/direnv.nix
    ./home/neovim.nix
    ./home/polybar.nix
    ./home/rofi.nix
    ./home/shell.nix
    ./home/sxhkd.nix
  ];

  home.packages = with pkgs; [
    _1password-gui
    authy
    aws-vault
    awscli2
    bats
    bottom
    brave
    calibre
    discord
    exercism
    fd
    firefox
    gh
    gnome.seahorse
    hfsprogs
    libreoffice
    mailspring
    neofetch
    nixfmt
    ripgrep
    scrot
    signal-cli
    signal-desktop
    slack
    spotify
    spotify-tui
    transmission-gtk
    wezterm
    yubikey-manager
    yubioath-desktop
  ];

  xdg.configFile."dunst/dunstrc".source = ./configs/dunst/dunstrc;
  xdg.configFile."wezterm/wezterm.lua".source = ./configs/wezterm/wezterm.lua;

  programs = {
    nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
    };

    lazygit.enable = true;
    gpg.enable = true;
    password-store.enable = true;
    feh.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "chris@amplified.ai";
      userName = "Christopher Grainger";
      extraConfig = {
        credential.helper = "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 40%" "--border" ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
      historyWidgetOptions = [ "--sort" "--exact" ];
    };

    bat = {
      enable = true;
      config = { theme = "Dracula"; };
      themes = {
        dracula = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
          sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
        } + "/Dracula.tmTheme");
      };
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      extraConfig = ''
        set  -g default-terminal "tmux-256color"
        set -ag terminal-overrides ",alacritty:RGB"
      '';
      clock24 = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [ dracula vim-tmux-navigator ];
    };

    zathura.enable = true;
  };

  services = {
    dunst.enable = true;

    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      pinentryFlavor = "gnome3";
    };

    picom = {
      enable = true;
      inactiveDim = "0.2";
      inactiveOpacity = "0.9";
      vSync = true;
    };

    spotifyd = {
      enable = true;
      package = (pkgs.spotifyd.override { withKeyring = true; });
      settings = {
        global = {
          username = "12169973823";
          device_name = "nix";
          use_keyring = true;
        };
      };
    };
  };
}
