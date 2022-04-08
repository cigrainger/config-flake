{ pkgs, config, ... }:

{
  imports = [
    ../../home/direnv.nix
    ../../home/helix.nix
    ../../home/mail.nix
    ../../home/shell.nix
  ];

  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    aws-vault
    awscli2
    bottom
    cachix
    exercism
    fd
    ffmpeg
    gh
    hfsprogs
    jq
    lazydocker
    libsecret
    ncdu
    neofetch
    networkmanager
    networkmanager-openvpn
    nix-tree
    onefetch
    ripgrep
    sd
    signal-cli
    ssm-session-manager-plugin
    tealdeer
    tree
    unzip
    xclip
    xh
    yubikey-manager
  ];

  programs = {
    zellij = {
      enable = true;
      settings = {
        theme = "dracula";
        themes.dracula.fg = [ 248 248 242 ];
        themes.dracula.bg = [ 40 42 54 ];
        themes.dracula.black = [ 0 0 0 ];
        themes.dracula.gray = [ 68 71 90 ];
        themes.dracula.red = [ 255 85 85 ];
        themes.dracula.green = [ 80 250 123 ];
        themes.dracula.yellow = [ 241 250 140 ];
        themes.dracula.blue = [ 98 114 164 ];
        themes.dracula.magenta = [ 255 121 198 ];
        themes.dracula.cyan = [ 139 233 253 ];
        themes.dracula.white = [ 255 255 255 ];
        themes.dracula.orange = [ 255 184 108 ];
        ui.pane_frames.rounded_corners = true;
      };
    };

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
    gpg = {
      enable = true;
      scdaemonSettings = { disable-ccid = true; };
    };
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
      ignores = [ ".nix-mix" ".nix-hex" ".direnv" "shell.nix" ".envrc" ];
      lfs.enable = true;
      userEmail = "chris@amplified.ai";
      userName = "Christopher Grainger";
      extraConfig = {
        core = { editor = "hx"; };
        url = { "https://github.com" = { insteadOf = "git://github.com/"; }; };
        credential.helper = "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
      };
      signing = {
        key = "2DAADC742D1B5395";
        signByDefault = true;
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
        dracula = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
            sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
          } + "/Dracula.tmTheme");
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      enableSshSupport = true;
      enableExtraSocket = true;
    };

    xcape = {
      enable = true;
      mapExpression = { "#66" = "Escape"; };
      timeout = 200;
    };
  };
}
