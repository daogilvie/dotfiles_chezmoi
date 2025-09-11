# JJ Config
set -g -x JJ_CONFIG ~/.config/jj.toml

# XTerm
set -g -x TERM xterm-ghostty

# Set nvim as editor
set -g -x EDITOR nvim
set -g -x VISUAL nvim

# And less as pager
set -g -x PAGER "less -FRX"
