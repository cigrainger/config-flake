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

    plugins = with pkgs.vimPlugins; [
	dracula-vim
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
      zls];
  };
}
