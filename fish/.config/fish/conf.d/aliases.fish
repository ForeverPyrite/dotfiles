# ~/.config/fish/conf.d/aliases.fish

# ------------------------------------------------------------------------------
# Core "Rust-first" Command Replacements
# ------------------------------------------------------------------------------
# These override the standard Unix commands with our modern alternatives.
# Note: Fish syntax doesn't use '=' for aliases.

alias cat "bat --paging=never" # Use bat to view files
alias grep "rg"                # Use ripgrep for searching
alias ls "eza --icons --group-directories-first" # The new default `ls`
alias find "fd" # fd-find. you're smart, you'll figure it out

# ------------------------------------------------------------------------------
# Enhanced `eza` Aliases
# ------------------------------------------------------------------------------
# Common shortcuts for different views.

# ll: long list, all files, show git status
alias ll "eza -l -a --git --icons --group-directories-first"

# la: list all files (including dotfiles)
alias la "eza -a --icons --group-directories-first"

# lt: tree view
alias lt "eza --tree --level=2 --long --git --icons"


# ------------------------------------------------------------------------------
# Context-Aware Aliases (Docker)
# ------------------------------------------------------------------------------
# These aliases are only defined if the `docker` command is available.

if command -v docker &> /dev/null
    # Simple aliases for docker-compose
    alias dc "docker compose"
    alias dcb "docker compose build"
    alias dcu "docker compose up -d"
    alias dcl "docker compose logs -f"
    
    # Your "full" command is better as a function for clarity
    # You can put this in functions.fish or define it right here!
    function dcf
        echo "==> Running 'docker compose up -d'..."
        docker compose up -d
        echo "==> Tailing logs with 'docker compose logs -f'..."
        docker compose logs -f
    end
end
