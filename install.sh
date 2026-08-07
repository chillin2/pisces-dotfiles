#!/usr/bin/env bash

set -Eeuo pipefail

REPO_URL="https://github.com/chillin2/pisces-dotfiles.git"
CONFIG_ROOT="${HOME}/.config"
SKIP_FONT=0
SKIP_NEOVIM_SYNC=0
SKIP_SHELL_CHANGE=0

step() {
    printf '\n\033[1;36m==> %s\033[0m\n' "$1"
}

usage() {
    cat <<'EOF'
Usage: install.sh [options]

Options:
  --skip-font          Do not install Nerd Fonts on macOS
  --skip-neovim-sync   Do not synchronize LazyVim plugins
  --skip-shell-change  Do not change the login shell to Fish
  -h, --help           Show this help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-font) SKIP_FONT=1 ;;
        --skip-neovim-sync) SKIP_NEOVIM_SYNC=1 ;;
        --skip-shell-change) SKIP_SHELL_CHANGE=1 ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

OS_NAME="$(uname -s)"
case "$OS_NAME" in
    Darwin)
        PLATFORM="macos"
        ;;
    Linux)
        if [[ ! -r /etc/os-release ]]; then
            printf 'Cannot identify this Linux distribution. Ubuntu is supported.\n' >&2
            exit 1
        fi
        # shellcheck disable=SC1091
        source /etc/os-release
        if [[ "${ID:-}" != "ubuntu" ]]; then
            printf 'Unsupported Linux distribution: %s. Ubuntu is supported.\n' "${ID:-unknown}" >&2
            exit 1
        fi
        PLATFORM="ubuntu"
        ;;
    *)
        printf 'Unsupported operating system: %s\n' "$OS_NAME" >&2
        exit 1
        ;;
esac

step "Preparing ${PLATFORM}"
if [[ "$PLATFORM" == "macos" ]]; then
    if ! xcode-select -p >/dev/null 2>&1; then
        printf 'Xcode Command Line Tools are required. Starting their installer now.\n'
        printf 'After installation finishes, run this one-shot command again.\n'
        xcode-select --install
        exit 0
    fi
else
    sudo apt-get update
    sudo apt-get install -y build-essential procps curl file git
fi

step "Installing Homebrew"
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if ! command -v brew >/dev/null 2>&1; then
    printf 'Homebrew installation finished, but brew is not on PATH. Open a new terminal and rerun the command.\n' >&2
    exit 1
fi

step "Installing command-line tools"
BREW_PACKAGES=(
    git
    neovim
    fish
    ripgrep
    fd
    fzf
    lazygit
    eza
    bat
    ghq
    llvm
)
brew install "${BREW_PACKAGES[@]}"

step "Configuring Git line endings"
git config --global core.autocrlf input

if [[ "$PLATFORM" == "macos" && "$SKIP_FONT" -eq 0 ]]; then
    step "Installing Nerd Fonts"
    brew install --cask font-plemol-jp-nf font-blex-mono-nerd-font
fi

step "Downloading dotfiles"
if [[ -d "${CONFIG_ROOT}/.git" ]]; then
    git -C "$CONFIG_ROOT" pull --ff-only
elif [[ -d "$CONFIG_ROOT" ]] && [[ -n "$(find "$CONFIG_ROOT" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
    printf '%s already exists and is not this Git repository. Move or back it up, then run the installer again.\n' "$CONFIG_ROOT" >&2
    exit 1
else
    git clone "$REPO_URL" "$CONFIG_ROOT"
fi

step "Installing Fish plugins"
fish -c '
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end
    fisher install IlanCosman/tide@v6 jethrokuan/z PatrickF1/fzf.fish jorgebucaran/nvm.fish
'

if [[ "$SKIP_NEOVIM_SYNC" -eq 0 ]]; then
    step "Synchronizing LazyVim plugins"
    if ! nvim --headless "+Lazy! sync" +qa; then
        printf 'Warning: Neovim plugin sync did not finish. Open nvim once after starting a new shell.\n' >&2
    fi
fi

if [[ "$SKIP_SHELL_CHANGE" -eq 0 ]]; then
    step "Setting Fish as the login shell"
    FISH_PATH="$(command -v fish)"
    if ! grep -Fxq "$FISH_PATH" /etc/shells; then
        printf '%s\n' "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    if [[ "${SHELL:-}" != "$FISH_PATH" ]]; then
        chsh -s "$FISH_PATH"
    fi
fi

step "Finished"
printf 'Dotfiles: %s\n' "$CONFIG_ROOT"
printf 'Close this terminal and open a new one to start Fish.\n'
if [[ "$PLATFORM" == "ubuntu" ]]; then
    printf 'Install a Nerd Font in your terminal application if icons are not displayed correctly.\n'
fi
