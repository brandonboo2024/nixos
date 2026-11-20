{ config, pkgs, ... }:
{
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;

  # No preNew fetch hook: the mbsync timer below fetches, then indexes.
  programs.notmuch = {
    enable = true;
    hooks.postNew = ''
      notmuch tag +emacs -inbox -- to:emacs-devel@gnu.org or cc:emacs-devel@gnu.org
      notmuch tag +linux -inbox -- to:linux-kernel@vger.kernel.org
      notmuch tag +nix -inbox -- to:nix-devel@googlegroups.com
    '';
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

    passwordCommand = "${pkgs.coreutils}/bin/cat ${config.xdg.configHome}/mail-passwd";

    mbsync = {
      enable = true;
      create = "maildir";
      expunge = "both";
      patterns = [ "*" ];
    };

    msmtp.enable = true;
  };

  # Fetch every 10 minutes, then index.
  services.mbsync = {
    enable = true;
    frequency = "*:0/10";
    postExec = "${pkgs.notmuch}/bin/notmuch new";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-tty
    '';
    maxCacheTtl = 86400;
    defaultCacheTtl = 86400;
  };
}
