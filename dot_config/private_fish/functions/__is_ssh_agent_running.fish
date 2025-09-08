function __is_ssh_agent_running -d "check an ssh agent is running"
    if test -f $SSH_ENV; and test -z "$SSH_AGENT_PID";
        source $SSH_ENV > /dev/null
    end

    if test -z "$SSH_AGENT_PID"; and test -z "$SSH_CONNECTION";
        return 1
    end

    ssh-add -l > /dev/null 2>&1
    if test $status -eq 2
        return 1
    end
end