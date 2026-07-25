{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = true;
    shellAliases = {
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
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
}
