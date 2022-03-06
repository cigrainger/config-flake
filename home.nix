{ pkgs, config, ... }:

{
  imports = [
    ./home/direnv.nix
    ./home/firefox.nix
    ./home/mail.nix
    ./home/neovim.nix
    ./home/shell.nix
  ];

  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    _1password-gui
    authy
    aws-vault
    awscli2
    bottom
    brave
    calibre
    cachix
    cider
    discord
    dmenu
    exercism
    fd
    filezilla
    gh
    gnome.gnome-tweaks
    gnomeExtensions.window-is-ready-remover
    hfsprogs
    jq
    lazydocker
    libreoffice
    libsecret
    mailspring
    mpv
    ncdu
    neofetch
    networkmanager
    networkmanager-openvpn
    onefetch
    postman
    ripgrep
    sd
    signal-cli
    signal-desktop
    slack
    ssm-session-manager-plugin
    tealdeer
    transmission-gtk
    tree
    udiskie
    unzip
    xclip
    xh
    yubikey-manager
    yubioath-desktop
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };

  programs = {
    broot = {
      enable = true;
      enableZshIntegration = true;
    };

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
      package = pkgs.nnn.override { withNerdIcons = true; };
      extraPackages = with pkgs; [ pmount udisks ];
      plugins = {
        mappings = {
          c = "fzcd";
          f = "finder";
          v = "imgview";
          t = "nmount";
        };
        src = (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.0";
          sha256 = "sha256-Hpc8YaJeAzJoEi7aJ6DntH2VLkoR6ToP6tPYn3llR7k=";
        }) + "/plugins";
      };
    };

    navi = {
      enable = true;
      enableZshIntegration = true;
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
      delta = {
        enable = true;
        options = {
          syntax-theme = "Dracula";
          side-by-side = true;
        };
      };
      ignores = [ ".nix-mix" ".nix-hex" ".direnv" "shell.nix" ];
      lfs.enable = true;
      userEmail = "chris@amplified.ai";
      userName = "Christopher Grainger";
      extraConfig = {
        core = { editor = "nvim"; };
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
      plugins = with pkgs.tmuxPlugins; [
        yank
        vim-tmux-navigator
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "cpu-usage ram-usage"
            set -g @dracula-show-flags true
            set -g @dracula-show-powerline true
          '';
        }
      ];
      extraConfig = ''
        set -g mouse on
      '';
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      pinentryFlavor = "gnome3";
    };

    xcape = {
      enable = true;
      mapExpression = { "#66" = "Escape"; };
      timeout = 200;
    };
  };
}
