{ pkgs, ... }:

{
  imports = [ ./home/neovim.nix ];

  home.packages = with pkgs; [
    _1password-gui
    aws-vault
    awscli2
    bottom
    brave
    fd
    firefox-devedition-bin
    gh
    gnome.gnome-tweaks
    hfsprogs
    mailspring
    neofetch
    nixfmt
    ripgrep
    signal-cli
    signal-desktop
    slack
    spotify
    spotify-tui
    yubikey-manager
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Orchis";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };

  xdg.configFile."nvim/lua" = {
    source = ./configs/nvim/lua;
    recursive = true;
  };

  programs = {
    alacritty.enable = true;
    lazygit.enable = true;
    gpg.enable = true;
    password-store.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
      stdlib = ''
        layout_poetry() {
          if [[ ! -f pyproject.toml ]]; then
            log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
            exit 2
          fi

          local VENV=$(poetry env list --full-path | cut -d' ' -f1)
          if [[ -z $VENV || ! -d $VENV/bin ]]; then
            log_error 'No poetry virtual environment found. Use `poetry install` to create one first.'
            exit 2
          fi

          export VIRTUAL_ENV=$VENV
          export POETRY_ACTIVE=1
          PATH_add "$VENV/bin"
        }
      '';
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

    zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      defaultKeymap = "viins";
      sessionVariables = {
        AWS_VAULT_PROMPT = "ykman";
      };
      zplug = {
        enable = true;
        plugins = [
          {
            name = "plugins/git";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "mafredri/zsh-async";
            tags = [ "from:github" ];
          }
          {
            name = "spaceship-prompt/spaceship-prompt";
            tags = [ "from:github" "use:spaceship.zsh" "as:theme" ];
          }
        ];
      };
    };

    bat = {
      enable = true;
      config = { theme = "Dracula"; };
    };


    tmux = {
      enable = true;
      baseIndex = 1;
      extraConfig = ''
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",xterm-256color:Tc"
      '';
      clock24 = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [ dracula vim-tmux-navigator ];
    };
  };

  services = {
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
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      pinentryFlavor = "gnome3";
    };
  };
}
