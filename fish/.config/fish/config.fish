# ~/.config/fish/config.fish

# --- Environment Variables ---
# Set a default editor (used by many command-line tools)
set -x EDITOR nvim

# --- PATH Configuration ---
# Add Cargo's bin directory to the path
fish_add_path "$HOME/.cargo/bin"

# --- Tool Initialization ---
# Starship Prompt
starship init fish | source

# Zoxide (replaces cd)
set -x FZF_DEFAULT_OPTS --tmux
zoxide init fish | source

# Autin (rip unencrypted .bash_history)
atuin init fish | source

# FZF Keybindings
# This sources the file installed by `fzf --all`
if test -f "$HOME/.fzf.fish"
    source "$HOME/.fzf.fish"
end


# --- ALIASES (The "Rust-first" way) ---
# Use 'alias' for simple command replacements.
# Note the syntax is 'alias new_command "old_command with args"'

alias ls 'eza --icons --group-directories-first' # a more feature-rich ls
alias ll 'eza -l --icons --group-directories-first'
alias la 'eza -la --icons --group-directories-first'
alias cat 'bat --paging=never' # bat is a better cat
alias grep 'rg' # ripgrep is a better grep
