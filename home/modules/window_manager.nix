{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # mangowc config
  wayland.windowManager.mango = {
    enable = true;
  };

}
