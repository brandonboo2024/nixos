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

      # Agent runs are long and largely autonomous, so let mako say when one
      # finishes rather than watching the terminal for it. No recursion here:
      # aliases expand only for interactive input, so notify-done itself
      # resolves the real binary on PATH.
      claude = "notify-done claude";
      codex = "notify-done codex";
      pi = "notify-done pi";
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
