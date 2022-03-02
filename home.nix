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
    dmenu
    exercism
    fd
    filezilla
    firefox
    gh
    hfsprogs
    jq
    lazydocker
    libreoffice
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
    udiskie
    unzip
    xclip
    xh
    yubikey-manager
    yubioath-desktop

    (st.overrideAttrs (oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
      patches = [
        ./patches/st-dracula.diff
        ./patches/st-font.diff
        # (fetchpatch {
        #   url =
        #     "https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.3.diff";
        #   sha256 = "0n4n83mffxp8i0c2hfaqabxbqz0as2yxx8v8ll76gxiihqa1hhd2";
        # })
        (fetchpatch {
          url =
            "https://st.suckless.org/patches/ligatures/0.8.4/st-ligatures-20210824-0.8.4.diff";
          sha256 = "0mh7p3k5fx84n80m639agk838x2pp6628w8sca1xjgv64dfic574";
        })
      ];
    }))
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
        credential.helper = "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
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

    udiskie.enable = true;
  };
}
