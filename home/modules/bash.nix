{
  lib,
  config,
  pkgs,
  input,
  ...
}:
let
  sioyekX11 = pkgs.writeShellScriptBin "sioyek-x11" ''
    exec env QT_QPA_PLATFORM=xcb ${pkgs.sioyek}/bin/sioyek "$@"
  '';
in
{
  home.packages = [
    sioyekX11
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      sioyek = "sioyek-x11";
      cat = "bat";
    };
    initExtra = ''
      export GPG_TTY=$(tty)
      function y() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
            yazi "$@" --cwd-file="$tmp"

            IFS= read -r -d "" cwd < "$tmp"

            [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
            rm -f -- "$tmp"
        }
        
      eval "$(starship init bash)"
    '';
  };
  programs.starship = {
    enable = true;
  };
}
