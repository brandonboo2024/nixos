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

  # River is configured via ~/nixos-dotfiles/config/river/init,
  # symlinked in base.nix. No home-manager river module needed.
}
