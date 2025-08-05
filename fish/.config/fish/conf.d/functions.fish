

# Sends a desktop notification after a command completes.
# Usage: long_running_command; alert
# Derived from the alias in the default .bashrc that I was interested in, probably will still never think to use it though lol
function alert
    # $status contains the exit code of the last command
    set -l last_status $status

    # Get the last command from history. Much cleaner than `history | tail | sed`.
    set -l last_cmd (history --max=1)

    if test $last_status -eq 0
        notify-send --urgency=low --icon=terminal "✅ Command Succeeded" "$last_cmd"
    else
        notify-send --urgency=critical --icon=error "❌ Command Failed (Exit Code: $last_status)" "$last_cmd"
    end
end
