{ pkgs, config, ... }:

{
  imports = [ ./home/direnv.nix ./home/neovim.nix ./home/shell.nix ];

  home.packages = with pkgs; [
    _1password-gui
    authy
    aws-vault
    awscli2
    bottom
    brave
    calibre
    cachix
    discord
    exercism
    fd
    firefox
    gh
    gnomeExtensions.screenshot-tool
    hfsprogs
    jq
    lazydocker
    libreoffice
    mailspring
    mpv
    neofetch
    nixfmt
    postman
    ripgrep
    sd
    signal-cli
    signal-desktop
    slack
    ssm-session-manager-plugin
    tealdeer
    transmission-gtk
    unzip
    vocal
    xclip
    yubikey-manager
    yubioath-desktop
  ];

  xdg.configFile."wezterm/wezterm.lua".source = ./configs/wezterm/wezterm.lua;

  dconf.settings = {
    "org/gnome/desktop/interface" = { text-scaling-factor = 1.25; };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-dark";
      package = pkgs.orchis-theme;
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
    nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
    };

    lazygit.enable = true;
    gpg.enable = true;
    password-store.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };

    git = {
      enable = true;
      ignores = [ ".nix-mix" ".nix-hex" ".direnv" "shell.nix" ];
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
      clock24 = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [ dracula vim-tmux-navigator ];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      pinentryFlavor = "gnome3";
    };
  };
}
