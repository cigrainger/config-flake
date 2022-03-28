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
    withNodeJs = true;
    withPython3 = true;

    extraConfig = "lua require('init')";
    extraPython3Packages = ps: with ps; [ isort black mypy ];

    plugins = let
      nvim-r = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-r";
        src = pkgs.fetchgit {
          url = "https://github.com/jalvesaq/nvim-r";
          rev = "5c0a6cd7137907f6f6e44d0b5705929bf537c2db";
          sha256 = "sha256-wmqmoYB/T2js+40K4UbB2g6IwvyOaaFq0bdWiFu68BM=";
        };
        buildInputs = with pkgs; [ which vim zip ];
      };
    in with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-vsnip
      diffview-nvim
      dracula-vim
      editorconfig-vim
      friendly-snippets
      gitsigns-nvim
      lsp-colors-nvim
      lsp_signature-nvim
      lualine-nvim
      markdown-preview-nvim
      neogit
      nvim-cmp
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-tree-lua
      nvim-web-devicons
      nvim-r
      null-ls-nvim
      octo-nvim
      project-nvim
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
      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
          tree-sitter-bash
          tree-sitter-bibtex
          tree-sitter-c
          tree-sitter-comment
          tree-sitter-css
          tree-sitter-dockerfile
          tree-sitter-elixir
          tree-sitter-erlang
          tree-sitter-heex
          tree-sitter-http
          tree-sitter-javascript
          tree-sitter-json
          tree-sitter-latex
          tree-sitter-lua
          tree-sitter-make
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-python
          tree-sitter-r
          tree-sitter-regex
          tree-sitter-rust
          tree-sitter-toml
          tree-sitter-tsx
          tree-sitter-typescript
          tree-sitter-yaml
          tree-sitter-zig
        ]))
    ];

    extraPackages = with pkgs; [
      actionlint
      clang-tools
      clippy
      codespell
      elixir_ls
      fd
      fzf
      gcc
      gh
      luajitPackages.luacheck
      mdl
      neovim-remote
      nixfmt
      nodePackages.bash-language-server
      nodePackages.eslint_d
      nodePackages.fixjson
      # nodePackages.lua-fmt
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
      shellcheck
      shellharden
      shfmt
      statix
      stylua
      sumneko-lua-language-server
      terraform
      tree-sitter
      xclip
      zls
    ];
  };
}
