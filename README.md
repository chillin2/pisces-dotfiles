## Install

```sh
git clone https://github.com/chillin2/pisces-dotfiles.git ~/.config
```

### Windows one-shot setup

Run this command in Windows PowerShell on a new Windows PC:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force; irm https://raw.githubusercontent.com/chillin2/pisces-dotfiles/agent/windows-scoop-cli-tools/install.ps1 | iex
```

The installer:

- installs PowerShell 7, Windows Terminal, Git and Oh My Posh with `winget`
- installs Scoop, then uses it for Neovim, ripgrep, fd, fzf, lazygit, eza and LLVM
- installs the required PowerShell modules
- clones or updates this repository at `~/.config`
- sets `XDG_CONFIG_HOME` so Neovim uses `~/.config/nvim`
- connects both PowerShell 7 and Windows PowerShell profiles
- backs up an existing profile before changing it
- installs Meslo Nerd Font and synchronizes LazyVim plugins
- can be run again safely to update the setup

Optional switches:

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/chillin2/pisces-dotfiles/agent/windows-scoop-cli-tools/install.ps1))) -SkipFont -SkipNeovimSync
```

If `winget` is unavailable, install or update **App Installer** from Microsoft Store first.

### macOS and Ubuntu one-shot setup

Run this command in Terminal on macOS or Ubuntu:

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

## Contents

- vim (Neovim) config
- fish config
- PowerShell config

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
  - [wezterm](https://github.com/wez/wezterm) **_(Linux, macOS & Windows)_**
  - [alacritty](https://github.com/alacritty/alacritty) **_(Linux, macOS & Windows)_**
  - [iTerm2](https://iterm2.com/) **_(macOS)_**

## Shell setup (macOS & Linux)

- [Fish shell](https://fishshell.com/)
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager
- [Tide](https://github.com/IlanCosman/tide) - Shell theme
- [Nerd fonts](https://github.com/ryanoasis/nerd-fonts) - Patched fonts for development use. I use [PlemolJP](https://github.com/yuru7/PlemolJP) and BlexMono.
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping
- [Eza](https://github.com/eza-community/eza) - `ls` replacement
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

## About me

- [Email: chilin2@naver.com](mailto:chilin2@naver.com)
- [Instagram: jw_just_chillin](https://www.instagram.com/jw_just_chillin/)
