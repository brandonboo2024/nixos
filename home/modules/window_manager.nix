{
  config,
  pkgs,
  inputs,
  ...
}:

{
  wayland.windowManager.mango = {
    enable = false;
  };
  
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      default-timeout = 5000;
      markup = true;
      font="monospace 10";
      anchor="top-right";
    };
  };

  # River is configured via ~/nixos-dotfiles/config/river/init,
  # symlinked in base.nix. No home-manager river module needed.
}
