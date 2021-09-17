{ pkgs, ... }:

{
  home.packages = with pkgs; [ nixfmt ripgrep fd gh aws-vault awscli2 ];

  xdg.configFile."nvim/lua" = {
    source = ./configs/nvim/lua;
    recursive = true;
  };

  programs = {
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
      signing = {
        key = "0xBFE2B86955E32D29";
        signByDefault = true;
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
      zplug = {
        enable = true;
        plugins = [
          { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
          { name = "mafredri/zsh-async"; tags = [ "from:github" ]; }
          { name = "sindresorhus/pure"; tags = [ "from:github" "use:pure.zsh" "as:theme" ]; }
        ];
      };
    };

    bat = {
      enable = true;
      config = { theme = "Dracula"; };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = "lua require('init')";
      extraPackages = with pkgs; [
        neovim-remote
        gcc
        tree-sitter
        nodePackages.pyright
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        nodePackages.vscode-json-languageserver
        nodePackages.yaml-language-server
        rnix-lsp
        sumneko-lua-language-server
        fzf
        ripgrep
        elixir_ls
      ];
      plugins = with pkgs.vimPlugins; [
        dracula-vim
        editorconfig-vim
        formatter-nvim
        friendly-snippets
        gitsigns-nvim
        lsp-colors-nvim
        lsp_signature-nvim
        lualine-nvim
        nvim-compe
        nvim-lspconfig
        nvim-tree-lua
        nvim-treesitter
        nvim-web-devicons
        rust-tools-nvim
        todo-comments-nvim
        vim-commentary
        vim-dadbod
        vim-fugitive
        vim-rooter
        vim-slime
        vim-speeddating
        vim-surround
        vim-terraform
        vim-test
        vim-tmux-navigator
        vim-vsnip
        which-key-nvim
        fzf-lsp-nvim
        fzf-vim
        vim-nix
        vim-elixir
      ];
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      extraConfig = "
        set -g default-terminal \"tmux-256color\"
      ";
      clock24 = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        dracula
        vim-tmux-navigator
      ];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      pinentryFlavor = "curses";
    };
  };
}
