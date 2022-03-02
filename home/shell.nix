{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true;
      defaultKeymap = "viins";
      history.extended = true;

      initExtra = ''
        # fe [FUZZY PATTERN] - Open the selected file with the default editor
        #   - Bypass fuzzy finder if there's only one match (--select-1)
        #   - Exit if there's no match (--exit-0)
        fe() {
          local files
          IFS=$'\n' files=($(fzf-tmux --height 80% --preview 'bat --color "always" {}' --query="$1" --multi --select-1 --exit-0))
          [[ -n "$files" ]] && ''${"EDITOR:-vim"} "''${files[@]}"
        }
      '';

      sessionVariables = {
        AWS_VAULT_PROMPT = "ykman";
        EDITOR = "vim";
      };

      shellAliases = {
        ave = "aws-vault exec";
        avl = "aws-vault login";
        cat = "bat";
        n = "nnn";
        br = "broot";
      };

    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        character = {
          success_symbol = "[→](bold green)";
          error_symbol = "[→](bold red)";
          vicmd_symbol = "[←](bold red)";
        };
      };
    };
  };
}
