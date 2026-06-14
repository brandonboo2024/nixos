{ config, pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  programs.notmuch = {
    enable = true;
    hooks.preNew = "mbsync -a";
  };

  accounts.email.maildirBasePath = "mail";

  accounts.email.accounts.posteo = {
    notmuch.enable = true;
    address = "jwboo@posteo.com";
    userName = "jwboo@posteo.com";
    realName = "Brandon Boo";
    primary = true;

    imap = {
      host = "posteo.de";
      port = 993;
      tls.enable = true;
    };

    smtp = {
      host = "posteo.de";
      port = 587;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };

    passwordCommand = "pass show posteo/jwboo@posteo.com";

    mbsync = {
      enable = true;
      create = "maildir";
      expunge = "both";
      patterns = [ "*" ];
    };

    msmtp.enable = true;
  };

  services.mbsync = {
    enable = true;
    frequency = "*:0/10";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
    '';
    defaultCacheTtl = 86400;
  };
}
