{ pkgs, ... }:

{
  home.packages = with pkgs; [
    actionlint
    clang-tools
    clippy
    codespell
    elixir_ls
    lldb
    mdl
    nixfmt
    nodePackages.bash-language-server
    nodePackages.eslint_d
    nodePackages.fixjson
    nodePackages.prettier
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
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
    zls
  ];

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "dracula";
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      languages = [
        { auto-format = true; name = "elixir"; }
        { auto-format = true; name = "nix"; }
        { auto-format = true; name = "r"; }
      ];
    };
  };
}
