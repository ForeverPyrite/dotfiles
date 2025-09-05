# ~/.config/fish/config.fish

# --- Environment Variables ---
# Set a default editor (used by many command-line tools)
set -x EDITOR nvim

# --- PATH Configuration ---
# Add Cargo's bin directory to the path
fish_add_path "$HOME/.cargo/bin"
# Add the local user bin to path as well
fish_add_path "$HOME/.local/bin"

# --- Tool Initialization ---
# Starship Prompt
starship init fish | source

# Zoxide (replaces cd)
set -x FZF_DEFAULT_OPTS --tmux
zoxide init --cmd cd fish | source

# Autin (rip unencrypted .bash_history)
atuin init fish | source

# FZF Keybindings
# This sources the file installed by `fzf --all`
if test -f "$HOME/.fzf.fish"
    source "$HOME/.fzf.fish"
end


# # Hopefully fixes the length errors in nvim
# set -gx XDG_CACHE_HOME "/tmp/.nv"


# Should I go ahead and `tmux start-server` in here?
