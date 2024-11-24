# If a login shell, we might need to check agents
# Adapted the setup from fish-ssh-agent package and various
# other sources. Checks if the agent is running because
# adding keys from the keychain takes a couple of seconds
# and simply isn't needed more than once per run of the agent.
if status --is-login
    if command -sq ssh-agent
        if test -z "$SSH_ENV"
            set -xg SSH_ENV $HOME/.ssh/environment
        end
        if not __is_ssh_agent_running
            ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
            chmod 600 $SSH_ENV
            source $SSH_ENV > /dev/null
            ssh-add -q --apple-load-keychain
        end
    end
end
