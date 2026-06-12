{ config, lib, pkgs, inputs, ... }:
let
  themes = import ../../home/themes.nix { inherit inputs pkgs; };
  hostThemes = {
    Prometheus = themes.yoga;
    Daedalus = themes.thinkpad;
    Hephaestus = themes.desktop_1;
  };
  hostDisplays = {
    Prometheus = {
      primary = "eDP-1";
      scale = 1.5;
    };
    Hephaestus = {
      primary = "DP-5";
      secondary = "HDMI-A-2";
      scale = 1.0;
    };
  };
  theme =
    hostThemes.${config.networking.hostName}
    or (throw "No greeter theme configured for host ${config.networking.hostName}");
  display = hostDisplays.${config.networking.hostName} or null;
  symbolMap = let
    mappings = [
      "U+23FB-U+23FE"
      "U+2B58"
      "U+E200-U+E2A9"
      "U+E0A0-U+E0A3"
      "U+E0B0-U+E0BF"
      "U+E0C0-U+E0C8"
      "U+E0CC-U+E0CF"
      "U+E0D0-U+E0D2"
      "U+E0D4"
      "U+E700-U+E7C5"
      "U+F000-U+F2E0"
      "U+2665"
      "U+26A1"
      "U+F400-U+F4A8"
      "U+F67C"
      "U+E000-U+E00A"
      "U+F300-U+F313"
      "U+E5FA-U+E62B"
    ];
  in
    (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
  kittyConfig = pkgs.writeText "greeter-kitty.conf" ''
    include ${pkgs.kitty-themes}/share/kitty-themes/themes/${theme.kitty.themeFile}.conf
    font_family ${theme.kitty.font.name}
    font_size ${toString theme.kitty.font.size}
    background_opacity ${toString theme.kitty.backgroundOpacity}
    confirm_os_window_close 0
    enable_audio_bell no
    cursor_shape block
    cursor_blink_interval 0
    symbol_map ${symbolMap}
  '';
  greeterApp = pkgs.writeShellScript "greeter-app" ''
    ${lib.optionalString (display != null) ''
      for _ in 1 2 3 4 5; do
        ${pkgs.wlr-randr}/bin/wlr-randr --output ${display.primary} --pos 0,0 --scale ${toString display.scale} && break
        ${pkgs.coreutils}/bin/sleep 0.2
      done
    ''}

    exec ${pkgs.kitty}/bin/kitty \
      --class tuigreet \
      --config NONE \
      --config ${kittyConfig} \
      ${pkgs.tuigreet}/bin/tuigreet --time \
        --remember --remember-user-session \
        --asterisks \
        --cmd "${pkgs.dbus}/bin/dbus-run-session mango" \
        --user-menu \
        --power-shutdown "sudo systemctl poweroff" \
        --power-reboot "sudo systemctl reboot"
  '';
  greeterSession = pkgs.writeShellScript "greeter-session" ''
    export HOME=/var/cache/tuigreet
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"
    log_file="$XDG_STATE_HOME/greeter.log"

    ${pkgs.coreutils}/bin/mkdir -p \
      "$XDG_CACHE_HOME" \
      "$XDG_CONFIG_HOME" \
      "$XDG_DATA_HOME" \
      "$XDG_STATE_HOME"

    exec ${pkgs.cage}/bin/cage -s -- ${greeterApp} >>"$log_file" 2>&1
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${greeterSession}";

        user = "greeter";
      };
    };
  };
}
