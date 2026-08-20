# Pisces Dotfiles

Personal development environment for Windows, macOS, and Ubuntu.

## Quick Install

### Windows

Open **Windows PowerShell** and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force; irm https://raw.githubusercontent.com/chillin2/pisces-dotfiles/main/install.ps1 | iex
```

The installer:

- installs PowerShell 7, Windows Terminal, Git and Oh My Posh with `winget`
- installs Scoop, then uses it for Neovim, ripgrep, fd, fzf, lazygit, eza, bat, mise and LLVM
- installs the required PowerShell modules
- clones or updates this repository at `~/.config`
- sets `XDG_CONFIG_HOME` so Neovim uses `~/.config/nvim`
- connects both PowerShell 7 and Windows PowerShell profiles
- backs up an existing profile before changing it
- activates mise-managed tools automatically in PowerShell when `mise` is available
- installs Meslo Nerd Font and synchronizes LazyVim plugins
- can be run again safely to update the setup

Optional switches:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/chillin2/pisces-dotfiles/main/install.ps1))) -SkipFont -SkipNeovimSync
```

If `winget` is unavailable, install or update **App Installer** from Microsoft Store first.

### macOS / Ubuntu

Open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/chillin2/pisces-dotfiles/main/install.sh | bash
```

The installer automatically detects macOS or Ubuntu and:

- installs Homebrew (and the required Ubuntu build tools)
- installs Git, Neovim, Fish, ripgrep, fd, fzf, lazygit, eza, bat, ghq and LLVM
- clones or updates this repository at `~/.config`
- installs Fisher, Tide, z, fzf.fish and nvm.fish
- synchronizes LazyVim plugins
- changes the login shell to Fish
- installs PlemolJP NF and BlexMono Nerd Font on macOS

On a fresh Mac, the first run may open the Xcode Command Line Tools installer. Finish that installation and run the same command again.

Optional switches:

```bash
curl -fsSL https://raw.githubusercontent.com/chillin2/pisces-dotfiles/main/install.sh -o /tmp/pisces-install.sh
bash /tmp/pisces-install.sh --skip-font --skip-neovim-sync --skip-shell-change
```

## Manual Install

If you only want to clone the dotfiles without running the setup script, use the command for your platform.

### Windows

```powershell
git clone https://github.com/chillin2/pisces-dotfiles.git "$HOME\.config"
```

### macOS / Linux

```bash
git clone https://github.com/chillin2/pisces-dotfiles.git ~/.config
```

The manual clone does not install dependencies or configure the shell automatically. For a new machine, the **Quick Install** method above is recommended.

## Contents

- Neovim / LazyVim config
- Fish config
- PowerShell config
- Windows one-shot setup script
- macOS / Ubuntu one-shot setup script

## Neovim setup

### Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [LazyVim](https://www.lazyvim.org/)
- a [Nerd Font](https://www.nerdfonts.com/) (v3.0 or greater) **_(optional, but needed to display some icons)_**
- [lazygit](https://github.com/jesseduffield/lazygit) **_(optional)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)
- for `telescope.nvim` **_(optional)_**
  - **live grep**: [ripgrep](https://github.com/BurntSushi/ripgrep)
  - **find files**: [fd](https://github.com/sharkdp/fd)
- a terminal that supports true color and *undercurl*:
  - [kitty](https://github.com/kovidgoyal/kitty) **_(Linux & macOS)_**
  - [wezterm](https://github.com/wezterm/wezterm) **_(Linux, macOS & Windows)_**
  - [alacritty](https://github.com/alacritty/alacritty) **_(Linux, macOS & Windows)_**
  - [iTerm2](https://iterm2.com/) **_(macOS)_**

## Shell setup (macOS & Linux)

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme
- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts for development use. I use [PlemolJP](https://github.com/yuru7/PlemolJP) and BlexMono.
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping
- [Eza](https://github.com/eza-community/eza) - `ls` replacement
- [bat](https://github.com/sharkdp/bat) - Syntax-highlighted `cat` replacement
- [ghq](https://github.com/x-motemen/ghq) - Local Git repository organizer
- [fzf](https://github.com/PatrickF1/fzf.fish) - Interactive filtering

## PowerShell setup (Windows)

- [Windows Package Manager](https://learn.microsoft.com/windows/package-manager/winget/) - Installs Windows-integrated applications
- [Scoop](https://scoop.sh/) - Installs and updates portable development tools
- [Git for Windows](https://gitforwindows.org/)
- [Oh My Posh](https://ohmyposh.dev/) - Prompt theme engine
- [Terminal Icons](https://github.com/devblackops/Terminal-Icons) - Folder and file icons
- [PSReadLine](https://learn.microsoft.com/powershell/module/psreadline/) - Command-line editing and history
- [PSFzf](https://github.com/kelleyma49/PSFzf) - Fuzzy finder
- [bat](https://github.com/sharkdp/bat) - Syntax-highlighted `cat` replacement and pager-friendly file viewer
- [mise](https://mise.jdx.dev/) - Development tool and runtime version manager

### Codex / Python project helper

The PowerShell profile includes an `init-codex` helper for projects where Codex needs Python tooling, such as editing Excel files with `openpyxl`.

First install `uv` once through mise:

```powershell
mise use -g uv@latest
```

Then, from a project root, run:

```powershell
init-codex
```

It configures Python 3.14 for the project, initializes a uv project without creating a Git repository, and installs `openpyxl`:

```text
mise use python@3.14
uv init --vcs none
uv add openpyxl
```

This is useful for SVN or other non-Git projects because `uv init --vcs none` does not create a `.git` directory.

## About me

- [Email: chilin2@naver.com](mailto:chilin2@naver.com)
- [Instagram: jw_just_chillin](https://www.instagram.com/jw_just_chillin/)
