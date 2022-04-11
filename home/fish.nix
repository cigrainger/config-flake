{ pkgs, ... }:

{
  programs = {
    atuin.enable = true;

    fish = {
      enable = true;

      interactiveShellInit = ''
        fish_vi_key_bindings insert
        set -Ux FZF_DEFAULT_OPTS "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
        set fzf_preview_dir_cmd exa --all --color=always
        set AWS_VAULT_PROMPT "ykman"
        set EDITOR "hx"
        set GIT_PAGER "delta --dark"
      '';

      shellAliases = {
        cat = "bat";
      };

      shellAbbrs = {
        ave = "aws-vault exec";
        avl = "aws-vault login";
        br = "broot";
        zj = "zellij";
      };

      plugins = [
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "17fcc74029bbd88445712752a5a71bc64aa3994c";
            sha256 = "sha256-WRrPd/GuXHJ9uYvhwjwp9AEtvbfMlpV0xdgNyfx43ok=";
          };
        }
        {
          name = "dracula";
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "fish";
            rev = "62b109f12faab5604f341e8b83460881f94b1550";
            sha256 = "sha256-0TlKq2ur2I6Bv7pu7JObrJxV0NbQhydmCuUs6ZdDU1I=";
          };
        }
      ];

      zellij = {
        enable = true;
        settings = {
          theme = "dracula";
          themes.dracula.fg = [ 248 248 242 ];
          themes.dracula.bg = [ 40 42 54 ];
          themes.dracula.black = [ 0 0 0 ];
          themes.dracula.gray = [ 68 71 90 ];
          themes.dracula.red = [ 255 85 85 ];
          themes.dracula.green = [ 80 250 123 ];
          themes.dracula.yellow = [ 241 250 140 ];
          themes.dracula.blue = [ 98 114 164 ];
          themes.dracula.magenta = [ 255 121 198 ];
          themes.dracula.cyan = [ 139 233 253 ];
          themes.dracula.white = [ 255 255 255 ];
          themes.dracula.orange = [ 255 184 108 ];
          ui.pane_frames.rounded_corners = true;
        };
      };

    };

    starship = {
      enable = true;
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
