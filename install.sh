#!/bin/bash
#
# Dotfiles Bootstrap Script
#
# This script automates the setup of a high-performance, Rust-powered
# command-line environment. It uses a hybrid sequential/parallel approach.
#
# Flags:
#   --extended: Performs a "desktop" setup: installs GUI fonts and changes the default shell.
#   --docker:   Installs Docker Engine.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Helper Functions for Logging ---
info() { echo -e "\033[1;34m==> $1\033[0m"; }
success() { echo -e "\033[1;32m✅ $1\033[0m"; }
warn() { echo -e "\033[1;33m⚠️ $1\033[0m"; }

# --- Argument Parsing & Environment Setup ---
EXTENDED_INSTALL=false
DOCKER_INSTALL=false
[[ " $* " =~ " --extended " ]] && EXTENDED_INSTALL=true
[[ " $* " =~ " --docker " ]] && DOCKER_INSTALL=true

# Phased installation package lists
PREREQ_PACKAGES=(git stow) # Git to clone my dotfiles repo, stow to symlink my conf from the cloned repo.
SYSTEM_PACKAGES=(curl tmux btop fish)
# Okay yes this may seem complete over-the-top oxidization, however:
RUST_PACKAGES=(
  eza             # Drop in `ls` replacement, more modern formatting, and even has a built in tree command! (The amount of times I've had to install tree...)
  bat             # Drop in `cat` replacement, more modern formatting, uhh "cat with wings" is what they said. I agree.
  ripgrep         # Drop in `grep` replacement, and it's FASTTTTTTTTTTTTTT. Has unironically saved me trying to find a file I misplaced so many times. FASTTTTTTTTTTTTTT.
  fd-find         # Drop in `find` replacement, and it's also FASTTTTTTTTTTTTTT. Very similar to `ripgrep`, but for file(path)s instead of file contents.
  zoxide          # Drop in `cd` replacement, can use `fzf` to...well...fuzzy find, and it also just knows where to go
  starship        # Super customizable cross-shell prompt. Very informative, yet very brief (at least, by default).
  bob-nvim        # Probably something I'll drop since installing up-to-date neovim seems like an impossible task. I'll figure out something...
  tree-sitter-cli # Dependancy for some neovim stuff.
  atuin           # This is kinda like zoxide, but for your shell commands. Pressing the up arrow now shows your entire command history, and you can fuzzy find through them. I imagine it's more secure than .bash_history too.
  dua-cli         # Disk-usage-analyzer. Plain and simple. For some reason I can't figure out how to find folder sizes (you probably can with `eza`), so this'll do. Useful for my limited storage cloud VPS and stuff.
  cargo-cache     # Actually just used for this script so far. It'll clean up all the, likely useless, sizable compiled dependancies used to build all of this.
)

# Global variables for system context
SUDO_CMD=""
PM=""
OS_ID=""

# --- Prerequisite Functions (Unchanged) ---
detect_os_and_pm() {
  info "Detecting OS and Package Manager..."
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    PM="brew"
  elif command -v apt-get &>/dev/null; then
    PM="apt-get"
  elif command -v dnf &>/dev/null; then
    PM="dnf"
  elif command -v pacman &>/dev/null; then
    PM="pacman"
  else
    warn "Could not detect a supported package manager (apt-get, dnf, pacman, brew)."
    exit 1
  fi
  info "Detected OS: ${OS_ID:-macOS}, Package Manager: $PM"
}

check_and_setup_sudo() {
  info "Checking for root privileges and sudo..."
  if [[ "$(id -u)" -eq 0 ]]; then
    info "Running as root. 'sudo' is not required."
    SUDO_CMD=""
    if ! command -v sudo &>/dev/null; then
      info "Sudo not found. Installing it for future convenience..."
      case "$PM" in
      apt-get) apt-get update && apt-get install -y sudo ;;
      dnf) dnf install -y sudo ;;
      pacman) pacman -S --noconfirm sudo ;;
      esac
    fi
  else
    if ! command -v sudo &>/dev/null; then
      warn "This script requires 'sudo' to be installed for non-root users."
      exit 1
    fi
    SUDO_CMD="sudo"
    info "Running as non-root user. Using 'sudo' for privileged operations."
  fi
}

install_build_tools() {
  info "Installing essential build tools for Rust..."
  case "$PM" in
  apt-get) $SUDO_CMD apt-get install -y build-essential ;;
  dnf) $SUDO_CMD dnf groupinstall -y "Development Tools" ;;
  pacman) $SUDO_CMD pacman -S --noconfirm --needed base-devel ;;
  esac
}

# lowk the best function tho
install_rust_toolchain() {
  if command -v cargo &>/dev/null; then info "Rust toolchain is already installed."; else
    info "Installing Rust and Cargo via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
  export PATH="$HOME/.cargo/bin:$PATH"
}

deploy_dotfiles() {
  info "Cloning and deploying dotfiles..."
  local dotfiles_repo="https://github.com/ForeverPyrite/dotfiles.git"
  local dotfiles_dir="$HOME/dotfiles"
  if [ ! -d "$dotfiles_dir" ]; then git clone "$dotfiles_repo" "$dotfiles_dir"; else info "Dotfiles directory already exists. Skipping clone."; fi
  info "Backing up any conflicting default config files..."
  local conflict_files=("$HOME/.bashrc" "$HOME/.profile" "$HOME/.bash_logout")
  for file in "${conflict_files[@]}"; do
    if [ -f "$file" ] && [ ! -L "$file" ]; then
      mv "$file" "$file.bak"
      info "  -> Moved $file to $file.bak"
    fi
  done
  info "Running 'stow' to link configurations..."
  cd "$dotfiles_dir"
  for dir in */; do [ -d "$dir" ] && stow "${dir%/}"; done
  cd - >/dev/null
  success "Dotfiles have been deployed."
}

# --- Parallel Installation Function ---
run_parallel_installs() {
  info "Handing off to Tmux for parallel tool installation..."
  local session_name="dotfiles"

  # --- Command Definitions ---
  # Note: if fish is set up in the .bashrc/.profile at this point, tmux sessions will start in fish, which messes up these commands (since they for bash).
  # Solution: bash -c 'command'
  local cargo_cmd="export PATH='$HOME/.cargo/bin:$PATH'; for pkg in ${RUST_PACKAGES[@]}; do cargo install --locked \$pkg; done && bob use stable && \
    sudo ln -s ~/.local/share/bob/nvim-bob/nvim /usr/bin/nvim && \
    cargo cache -a -y && \  
    echo '✅ Cargo packages installed, Neovim set up, and cache cleaned.'"
  local fzf_cmd="git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all && echo '✅ fzf installed.'"
  local tpm_cmd="git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && echo '✅ Tmux Plugin Manager installed.'"

  # --- Create Layout & Send Commands ---
  # This robust method creates the entire layout first, then sends commands to the numbered panes.
  tmux start-server
  # Pane 0
  tmux new-session -d -s "$session_name"
  # Pane 1
  tmux split-window -h -t "$session_name:1.1"
  # Pane 2
  tmux split-window -v -t "$session_name:1.2"

  # Send commands to their respective panes
  # Yeah, I talked about `bash -c 'command'`, but I don't wanna test all that right now
  tmux send-keys -t "$session_name:1.1" "$cargo_cmd" C-m
  tmux send-keys -t "$session_name:1.2" "$tpm_cmd" C-m
  tmux send-keys -t "$session_name:1.3" "$fzf_cmd" C-m

  # Handle optional installs in new windows
  if [ "$DOCKER_INSTALL" = true ]; then
    tmux new-window -t "$session_name" -n "Docker"
    local docker_cmd="curl -fsSL https://get.docker.com | $SUDO_CMD sh && echo '✅ Docker installed.'"
    tmux send-keys -t "$session_name:Docker" "$docker_cmd" C-m
  fi
  if [ "$EXTENDED_INSTALL" = true ]; then
    tmux new-window -t "$session_name" -n "Desktop"

    # Pane 1: Font Installation
    local font_cmd="mkdir -p ~/.local/share/fonts && curl -fLo f.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.tar.xz && tar -xf f.tar.xz -C ~/.local/share/fonts && rm f.tar.xz && fc-cache -fv && echo '✅ Fonts installed.'"
    tmux send-keys -t "$session_name:Desktop.1" "$font_cmd" C-m

    # Split the window for the next commands
    tmux split-window -h -t "$session_name:Desktop.1"
    tmux split-window -v -t "$session_name:Desktop.2"

    # Pane 2: Change Shell
    local shell_cmd="FISH_PATH=\$(which fish); if ! grep -q \"\$FISH_PATH\" /etc/shells; then echo \"\$FISH_PATH\" | $SUDO_CMD tee -a /etc/shells; fi; $SUDO_CMD chsh -s \"\$FISH_PATH\" \"$USER\" && echo '✅ Shell changed.'"
    tmux send-keys -t "$session_name:Desktop.2" "$shell_cmd" C-m
    warn "The 'chsh' command inside tmux may require your password to complete."

    # Pane 3: Install Alacritty
    # Oh the unfortunate life of this command.
    # See, you can build alacritty from source via cargo, however, to do that I would need to install all the build dependancies...and like...there's a certain point where it's just not worth it.
    local alacritty_install_cmd
    case "$PM" in
    # wait where is GUI_PACKAGES defined? is it even defined? oh god.
    brew) alacritty_install_cmd="brew install --cask ${GUI_PACKAGES[*]}" ;;
    apt-get) alacritty_install_cmd="$SUDO_CMD apt-get install -y ${GUI_PACKAGES[*]}" ;;
    dnf) alacritty_install_cmd="$SUDO_CMD dnf install -y ${GUI_PACKAGES[*]}" ;;
    pacman) alacritty_install_cmd="$SUDO_CMD pacman -S --noconfirm ${GUI_PACKAGES[*]}" ;;
    esac
    alacritty_install_cmd+=" && echo '✅ Alacritty installed.'"
    tmux send-keys -t "$session_name:Desktop.3" "$alacritty_install_cmd" C-m
  fi
  success "Tmux session '$session_name' created. Attach with: tmux a -t $session_name"
}

# --- Main Execution ---
# Phase 0: System Detection & Prerequisite Installation
detect_os_and_pm
check_and_setup_sudo
info "Phase 0: Installing prerequisites (git, stow)..."
case "$PM" in
brew) brew install "${PREREQ_PACKAGES[@]}" ;;
apt-get) $SUDO_CMD apt-get update && $SUDO_CMD apt-get install -y "${PREREQ_PACKAGES[@]}" ;;
dnf)
  if [[ "$OS_ID" == "ol" || "$OS_ID" == "almalinux" || "$OS_ID" == "rockylinux" || "$OS_ID" == "centos" ]]; then $SUDO_CMD dnf install -y epel-release --nogpgcheck; fi
  $SUDO_CMD dnf install -y "${PREREQ_PACKAGES[@]}"
  ;;
pacman) $SUDO_CMD pacman -Syu --noconfirm "${PREREQ_PACKAGES[@]}" ;;
esac
success "Prerequisites installed."

# Phase 1: Deploy Configurations
deploy_dotfiles

# Phase 2: Core System Installation
info "Phase 2: Installing core system tools..."
case "$PM" in
brew) brew install "${SYSTEM_PACKAGES[@]}" ;; apt-get) $SUDO_CMD apt-get install -y "${SYSTEM_PACKAGES[@]}" ;;
dnf) $SUDO_CMD dnf install -y "${SYSTEM_PACKAGES[@]}" ;; pacman) $SUDO_CMD pacman -S --noconfirm "${SYSTEM_PACKAGES[@]}" ;;
esac
install_build_tools
install_rust_toolchain
success "Core system tools installed."

# Phase 3: Parallel Tool Installation
run_parallel_installs # unfortunate part of this is that it'll require your password/sudo auth quite a bit.
# I think it would be cool to be able to run this script without root, given prerequisites are installed, since cargo installed binaries are stored in `~/.cargo/bin`
# All the system needs is "git", "stow", and a few build tools. rustup is installed without sudo just fine too.
# I'm not sure why I'm acting like I'd use this script on a multi-user system: I'd just ssh into my own machines.

# --- Final Message ---
echo ""
info "--------------------------------------------------------"
success "Bootstrap script finished!"
info "Monitor the rest of the installation inside tmux: tmux a -t dotfiles_setup"
info "Log out and log back in to apply all changes, especially the new shell."
info "--------------------------------------------------------"
