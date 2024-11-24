if test "$TERM_PROGRAM" = "iTerm.app"
    test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
    set -x ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX YES
end

# Set nvim as editor
set -g -x EDITOR nvim
set -g -x VISUAL nvim

# And less as pager
set -g -x PAGER "less -FRX"

if test "$TERM_PROGRAM" != "WarpTerminal"
    # Enable VI mode bindings
    fish_vi_key_bindings
end
