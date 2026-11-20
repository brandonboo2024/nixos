{ ... }:

# Shell init for starship, yazi (`y`), fzf and GPG_TTY comes from their own
# modules; do not repeat it in initExtra.
{
  programs.bash = {
    enable = true;
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];
    historySize = 50000;
    historyFileSize = 100000;
    shellOptions = [
      "histappend"
      "extglob"
      "globstar"
      "checkjobs"
      "checkwinsize"
    ];
    shellAliases = {
      cat = "bat";
    };
    # Append history on each prompt so concurrent tmux panes and Ghostel
    # buffers do not overwrite ~/.bash_history, and emit OSC 133 prompt
    # markers for Foot. Home Manager places initExtra before starship init,
    # and starship wraps pre-existing PROMPT_COMMAND while preserving $?.
    initExtra = ''
      _my_prompt_hook() {
        history -a
        case "''${TERM:-}" in
          foot*) printf '\e]133;A\e\\' ;;
        esac
      }
      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }_my_prompt_hook"
      case "''${TERM:-}" in
        foot*) PS0=$'\e]133;C\e\\' ;;
      esac
    '';
  };
  # Ctrl-R history, Ctrl-T file picker, Alt-C directory jump, and completion.
  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidget.command = "fd --type f --hidden --exclude .git";
    changeDirWidget.command = "fd --type d --hidden --exclude .git";
  };
  programs.starship = {
    enable = true;
  };
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
}
