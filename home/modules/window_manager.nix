{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # programs.mangowc.enable = true;

  services.mako = {
    enable = true;
    settings = {
      actions = true;
      default-timeout = 5000;
      markup = true;
      font = "monospace 25";
      anchor = "top-right";
      width = 600;
      height = 200;
    };
  };

  services.swayidle =
    let
      lock = "~/nixos/config/scripts/swaylock.sh";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 30;
          command = "${pkgs.libnotify}/bin/notify-send Locking in 10 seconds...";
        }
        {
          timeout = 40;
          command = lock;
        }
        {
          timeout = 940;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };

  # River is configured via ~/nixos-dotfiles/config/river/init,
  # symlinked in base.nix. No home-manager river module needed.
}
