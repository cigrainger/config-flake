{ pkgs, ... }:

{
  programs.zsh = {
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
    };

    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "mafredri/zsh-async";
          tags = [ "from:github" ];
        }
        {
          name = "spaceship-prompt/spaceship-prompt";
          tags = [ "from:github" "use:spaceship.zsh" "as:theme" ];
        }
      ];
    };
  };
}
