{ pkgs, config, ... }:

{
  imports = [
    ../../home/direnv.nix
    ../../home/helix.nix
    ../../home/mail.nix
    ../../home/fish.nix
  ];

  home.stateVersion = "21.11";

  home.packages = with pkgs; [
    aws-vault
    awscli2
    bottom
    cachix
    exercism
    du-dust
    fd
    ffmpeg
    fzf
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
    tig
    tree
    unzip
    which
    xclip
    xh
    xplr
    xsv
    yubikey-manager
  ];

  programs = {
    broot.enable = true;
    navi.enable = true;

    lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "b";
            command = "tig blame -- {{.SelectedFile.Name}}";
            context = "files";
            description = "blame file at tree";
            subprocess = true;
          }
          {
            key = "b";
            command = "tig blame {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
            context = "commitFiles";
            description = "blame file at revision";
            subprocess = true;
          }
          {
            key = "B";
            command = "tig blame -- {{.SelectedCommitFile.Name}}";
            context = "commitFiles";
            description = "blame file at tree";
            subprocess = true;
          }
          {
            key = "t";
            command = "tig -- {{.SelectedFile.Name}}";
            context = "files";
            description = "tig file (history of commits affecting file)";
            subprocess = true;
          }
          {
            key = "t";
            command = "tig {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
            context = "commitFiles";
            description = "tig file (history of commits affecting file)";
            subprocess = true;
          }
          {
            key = "<c-r>";
            command = "gh pr create --fill --web";
            context = "global";
            description = "create pull request";
            subprocess = true;
            loadingText = "Creating pull request on GitHub";
          }
        ];
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };

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

    zoxide.enable = true;
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
