# Disable virtualenv's default ugly prompt.
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

if test "$TERM_PROGRAM" = "WarpTerminal"
    # Define the empty fish_mode_prompt function
    # to avoid having [I] being inserted into the input
    # by Warp
    function fish_mode_prompt
    end
else
    if status --is-interactive
        # Activate starship prompt
        if command -sq starship
         starship init fish | source
        end
    end
end
