# --- Environment Variables ---
# Set a default editor (used by many command-line tools)
set -x EDITOR nvim

# --- PATH Configuration ---
# Add Cargo's bin directory to the path
fish_add_path "$HOME/.cargo/bin"
# Add the local user bin to path as well
fish_add_path "$HOME/.local/bin"
# Add bob's nvim bin to path
fish_add_path "$HOME/.local/share/bob/nvim-bin"

# --- Tool Initialization ---
# Zoxide (replaces cd)
zoxide init --cmd cd fish | source

# Autin (rip unencrypted .bash_history)
atuin init fish | source

# FZF Keybindings
# This sources the file installed by `fzf --all`
if test -f "$HOME/.fzf.fish"
    source "$HOME/.fzf.fish"
end

# --- Appearance ---
# While the GitHub says to use `fish theme save`, I think it's either
# outdated or slightly incorrect. 
fish_config theme choose "Catppuccin Mocha"
# I also want to either swap some of the Catppuccin colors around,
# or break the Catppuccin theme for my shell since it makes the most
# sense to be the most personalized.
# What I normally do is a lot of cyan and purple though, which isn't
# the most appealing.
# Perhaps when I get to that I'll customize Starship a little more too...

# Starship Prompt
starship init fish | source

# --- Forcing Tmux Upon Thyself ---
# I keep doing all these things with tmux and looking at tpm plugins,
# yet for some reason I'm not always using it
#
# Should only activate in a terminal emulator though, since it starting
# with the env of the tty instead of the wayland session is really
# annoying tbh

if tty | string match --quiet --regex '^/dev/tty[0-9]+$'
    # Making it a varible just in case I wanna change it some day
    set DEFAULT_SESSION home
    if status is-interactive && not set -q TMUX
        tmux attach -t $DEFAULT_SESSION || tmux new-session -s $DEFAULT_SESSION
    end
end
