{ pkgs, ... }:

{
  xdg.configFile."nvim/lua" = {
    source = ../configs/nvim/lua;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = "lua require('init')";

    extraPackages = with pkgs; [
      clippy
      elixir_ls
      fd
      fzf
      gcc
      gh
      neovim-remote
      nixfmt
      nodePackages.bash-language-server
      nodePackages.lua-fmt
      nodePackages.prettier
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      nodejs
      ripgrep
      rnix-lsp
      rust-analyzer
      rustfmt
      sumneko-lua-language-server
      tree-sitter
      xclip
      zls
    ];

    plugins = let
      blamer-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "blamer.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "APZelos";
          repo = "blamer.nvim";
          rev = "ab4dc40a1df02ede465e09039c38922db3aceadb";
          sha256 = "sha256-LQFkutPyVNOxa+nwW/SWn7iYxv0Gu86VqpYpBYusyx8=";
        };
      };
      octo-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "octo.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "pwntester";
          repo = "octo.nvim";
          rev = "848990b8d7f7f28293cfb5a1ad19abf66e27f08a";
          sha256 = "sha256-+vHclNUot8EPSMhC7x805LGt6oaF4qO3/DbKQ2q6KyY=";
        };
      };
    in with pkgs.vimPlugins; [
      barbar-nvim
      blamer-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-vsnip
      dracula-vim
      editorconfig-vim
      formatter-nvim
      friendly-snippets
      gitsigns-nvim
      lsp-colors-nvim
      lsp_signature-nvim
      lualine-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-tree-lua
      nvim-treesitter
      nvim-web-devicons
      octo-nvim
      rust-tools-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      todo-comments-nvim
      trouble-nvim
      vim-commentary
      vim-dadbod
      vim-dadbod-ui
      vim-elixir
      vim-fugitive
      vim-nix
      vim-rooter
      vim-slime
      vim-speeddating
      vim-surround
      vim-terraform
      vim-test
      vim-tmux-navigator
      vim-vsnip
      which-key-nvim
      wilder-nvim
      zig-vim
    ];
  };
}
