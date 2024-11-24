# Hook in Mise if present, else try asdf
if command -sq mise
    if status is-interactive
      mise activate fish | source
      # We hook-env here to enable access to mise-installed tools later on
      mise hook-env -s fish | source
    else
      mise activate fish --shims | source
    end
else if test -d ~/.asdf
    source ~/.asdf/asdf.fish
    if ! test -L ~/.config/fish/completions/asdf.fish
        mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    end
end

# Hook in zoxide if present
if command -sq zoxide
    zoxide init fish | source
end

# Atuin for shell history
if test -d ~/.atuin
    source "$HOME/.atuin/bin/env.fish"
end

if command -sq jj
    jj util completion fish | source
end

if status is-interactive; and command -sq atuin
    atuin init --disable-up-arrow fish | source
end
