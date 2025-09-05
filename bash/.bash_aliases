# Including this from .bashrc because maybe I'll remember it exists and find a use for it if I put it here.
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

### Actually mine ###

# Rust drop-ins
alias cat="bat --paging=never"
alias grep="rg"
alias ls="eza --icons --group-directories-first"

# More eza aliases
# ll: long list, all files, show git status
alias ll="eza -l -a --git --icons --group-directories-first"

# la: list all files (including dotfiles)
alias la="eza -a --icons --group-directories-first"

# lt: tree view
alias lt="eza --tree --level=2 --long --git --icons"

# If docker is actually installed on the host...
if command docker -v &>/dev/null; then
  alias dc="docker compose"
  alias dcd="dc down"
  alias dcb="dc build"
  alias dcu="dc up -d"
  alias dcl="dc logs -f"
  alias dcf="dcu && dcl" # Think "docker compose full", yes all of this is peak laziness but this is probably my most used command.
fi
