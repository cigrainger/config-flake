{ pkgs, ... }:

{
  xdg.configFile."neomutt/dracula.muttrc" = {
    source = ../configs/neomutt/dracula.muttrc;
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;

    neomutt = {
      enable = true;
      sidebar.enable = true;
      extraConfig = ''
        source ~/.config/neomutt/dracula.muttrc
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
      imap = {
        host = "imap.fastmail.com";
        port = 993;
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      neomutt = { enable = true; };
      notmuch.enable = true;
      primary = true;
      smtp = {
        host = "smtp.fastmail.com";
        port = 465;
      };
      realName = "Christopher Grainger";
      userName = "chris@cigrainger.com";
      passwordCommand = "secret-tool lookup email chris@cigrainger.com";
    };
  };
}
