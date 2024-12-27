# Homebrew
if test -f /opt/homebrew/bin/brew
  eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Set gopath
set -g -x GOPATH ~/go
fish_add_path ~/go/bin

# Add Cargo to path
fish_add_path ~/.cargo/bin

# Add .local/bin to path (used by pipsi)
fish_add_path ~/.local/bin

# Add the icubin for paths
fish_add_path /usr/local/opt/icu4c/bin
fish_add_path /usr/local/opt/icu4c/sbin

# Add sbin
fish_add_path /usr/local/sbin

# Rancher Desktop
fish_add_path ~/.rd/bin
