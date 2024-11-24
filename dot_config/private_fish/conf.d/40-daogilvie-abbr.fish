if command -v eza >/dev/null
    abbr -a l 'eza'
    abbr -a ls 'eza'
    abbr -a ll 'eza -l'
    abbr -a lll 'eza -la'
    abbr -a tree 'eza --tree'
else
    abbr -a l 'ls'
    abbr -a ll 'ls -l'
    abbr -a lll 'ls -la'
end
if command -v nvim >/dev/null
    abbr -a e 'nvim'
    abbr -a vim 'nvim'
    abbr -a vdiff 'nvim --diff'
    abbr -a nvses 'nvim -S Session.vim'
end
if command -v git machete >/dev/null
    abbr -a gm 'git machete'
end
