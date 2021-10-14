{ pkgs, ... }:

{
    programs.neovim = {
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
        nixfmt
        rustfmt
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

}
