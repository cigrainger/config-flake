{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    rPackages.formatR
    rPackages.languageserver
    rWrapper
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

  programs = {
    helix = {
      enable = true;
      settings = { theme = "dracula"; };
      languages = [
        { auto-format = true; name = "elixir"; }
        { auto-format = true; name = "nix"; }
      ];
    };
  };
}
