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
          [[ -n "$files" ]] && ''${"EDITOR:-hx"} "''${files[@]}"
        }
      '';

      sessionVariables = {
        AWS_VAULT_PROMPT = "ykman";
        EDITOR = "hx";
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
        command_timeout = 1000;
        aws.style = "bold #ffb86c";
        cmd_duration.style = "bold #f1fa8c";
        directory.style = "bold #50fa7b";
        hostname.style = "bold #ff5555";
        git_branch.style = "bold #ff79c6";
        git_status.style = "bold #ff5555";
        username = {
          format = "[$user]($style) on ";
          style_user = "bold #bd93f9";
        };
        character = {
          success_symbol = "[λ](bold #50fa7b)";
          error_symbol = "[λ](bold #ff5555)";
          vicmd_symbol = "[λ](bold #ffb86c)";
        };
      };
    };
  };
}
