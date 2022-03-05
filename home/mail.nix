{ pkgs, ... }:

# NOTE: Watch for [`himalaya`](https://github.com/soywod/himalaya) to be ready.

{
  xdg.configFile."neomutt" = {
    source = ../configs/neomutt;
    recursive = true;
  };

  home.packages = with pkgs; [ lynx urlview ];

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;

    neomutt = {
      enable = true;
      sidebar.enable = true;
      extraConfig = ''
        source ~/.config/neomutt/dracula.muttrc
        set mailcap_path = ~/.config/neomutt/mailcap
        auto_view text/html
      '';
    };

    notmuch = {
      enable = true;
      hooks = { preNew = "mbsync --all"; };
    };
  };

  accounts.email.accounts = {
    cigrainger = {
      address = "chris@cigrainger.com";
      flavor = "fastmail.com";
      folders.trash = "Archive";
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      neomutt = { enable = true; };
      notmuch.enable = true;
      primary = true;
      realName = "Christopher Grainger";
      userName = "chris@cigrainger.com";
      passwordCommand = "secret-tool lookup email chris@cigrainger.com";
    };
  };
}
