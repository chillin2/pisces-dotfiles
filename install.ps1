#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$SkipFont,
    [switch]$SkipNeovimSync
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$repoUrl = "https://github.com/chillin2/pisces-dotfiles.git"
$configRoot = Join-Path $HOME ".config"
$profileSource = Join-Path $configRoot "powershell\user_profile.ps1"
$managedStart = "# >>> pisces-dotfiles >>>"

function Write-Step {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)][string]$Name
    )

    $installed = winget list --id $Id --exact --accept-source-agreements 2>$null
    if ($LASTEXITCODE -eq 0 -and ($installed -match [regex]::Escape($Id))) {
        Write-Host "  [skip] $Name"
        return
    }

    Write-Host "  [install] $Name"
    winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $Name ($Id)."
    }
}

function Install-ScoopPackage {
    param(
        [Parameter(Mandatory)][string]$Package,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$Command
    )

    $scoopRoot = if ($env:SCOOP) { $env:SCOOP } else { Join-Path $HOME "scoop" }
    $installedPath = Join-Path $scoopRoot "apps\$Package\current"
    if (Test-Path $installedPath) {
        Write-Host "  [skip] $Name"
        return
    }

    $existingCommand = Get-Command $Command -ErrorAction SilentlyContinue
    if ($existingCommand -and $existingCommand.Source -notmatch "[\\/]scoop[\\/]shims[\\/]") {
        Write-Warning "$Name is already installed outside Scoop: $($existingCommand.Source). Skipping to avoid a duplicate installation."
        return
    }

    Write-Host "  [install:scoop] $Name"
    scoop install $Package
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install $Name with Scoop ($Package)."
    }
}

function Install-RequiredModule {
    param([Parameter(Mandatory)][string]$Name)

    if (Get-Module -ListAvailable -Name $Name) {
        Write-Host "  [skip] PowerShell module $Name"
        return
    }

    Write-Host "  [install] PowerShell module $Name"
    Install-Module -Name $Name -Scope CurrentUser -Force -AllowClobber
}

function Add-ProfileLoader {
    param([Parameter(Mandatory)][string]$ProfilePath)

    $profileDirectory = Split-Path -Parent $ProfilePath
    if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
    }

    $existing = if (Test-Path $ProfilePath) {
        Get-Content -Raw -Path $ProfilePath
    } else {
        ""
    }

    if ($existing -match [regex]::Escape($managedStart)) {
        Write-Host "  [skip] $ProfilePath"
        return
    }

    if (Test-Path $ProfilePath) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        Copy-Item $ProfilePath "$ProfilePath.$timestamp.bak"
    }

    $loader = @'

# >>> pisces-dotfiles >>>
$piscesProfile = Join-Path $HOME ".config\powershell\user_profile.ps1"
if (Test-Path $piscesProfile) {
    . $piscesProfile
}
# <<< pisces-dotfiles <<<
'@

    Add-Content -Path $ProfilePath -Value $loader -Encoding UTF8
    Write-Host "  [configured] $ProfilePath"
}

Write-Step "Checking Windows Package Manager"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Update or install 'App Installer' from Microsoft Store, then run this command again."
}

Write-Step "Installing Windows applications with winget"
$wingetPackages = @(
    @{ Id = "Microsoft.PowerShell"; Name = "PowerShell 7" },
    @{ Id = "Microsoft.WindowsTerminal"; Name = "Windows Terminal" },
    @{ Id = "Git.Git"; Name = "Git for Windows" },
    @{ Id = "JanDeDobbeleer.OhMyPosh"; Name = "Oh My Posh" }
)

foreach ($package in $wingetPackages) {
    Install-WingetPackage -Id $package.Id -Name $package.Name
}

Refresh-Path

Write-Step "Checking Scoop"
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  [install] Scoop"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

    $scoopInstaller = Join-Path ([System.IO.Path]::GetTempPath()) "install-scoop.ps1"
    Invoke-WebRequest -Uri "https://get.scoop.sh" -OutFile $scoopInstaller

    try {
        $windowsPowerShell = Join-Path $env:SystemRoot "System32\WindowsPowerShell\v1.0\powershell.exe"
        & $windowsPowerShell -NoProfile -ExecutionPolicy Bypass -File $scoopInstaller
        if ($LASTEXITCODE -ne 0) {
            throw "Scoop installer exited with code $LASTEXITCODE."
        }
    } finally {
        Remove-Item -Path $scoopInstaller -Force -ErrorAction SilentlyContinue
    }

    Refresh-Path
}

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    throw "Scoop installation finished, but the scoop command was not found."
}

Write-Step "Installing development tools with Scoop"
$scoopPackages = @(
    @{ Package = "neovim"; Name = "Neovim"; Command = "nvim" },
    @{ Package = "ripgrep"; Name = "ripgrep"; Command = "rg" },
    @{ Package = "fd"; Name = "fd"; Command = "fd" },
    @{ Package = "fzf"; Name = "fzf"; Command = "fzf" },
    @{ Package = "lazygit"; Name = "lazygit"; Command = "lazygit" },
    @{ Package = "eza"; Name = "eza"; Command = "eza" },
    @{ Package = "bat"; Name = "bat"; Command = "bat" },
    @{ Package = "llvm"; Name = "LLVM"; Command = "clang" }
)

foreach ($package in $scoopPackages) {
    Install-ScoopPackage -Package $package.Package -Name $package.Name -Command $package.Command
}

Refresh-Path

Write-Step "Configuring Git line endings"
git config --global core.autocrlf true
if ($LASTEXITCODE -ne 0) {
    throw "Could not configure Git line endings."
}

Write-Step "Installing PowerShell modules"
if (-not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion "2.8.5.201" -Force | Out-Null
}

$repository = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
if (-not $repository) {
    Register-PSRepository -Default
    $repository = Get-PSRepository -Name PSGallery
}
if ($repository.InstallationPolicy -ne "Trusted") {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

@("posh-git", "Terminal-Icons", "PSFzf", "PSReadLine") |
    ForEach-Object { Install-RequiredModule -Name $_ }

Write-Step "Downloading dotfiles"
if (Test-Path (Join-Path $configRoot ".git")) {
    git -C $configRoot pull --ff-only
    if ($LASTEXITCODE -ne 0) {
        throw "Could not update $configRoot. Check its Git status."
    }
} elseif (Test-Path $configRoot) {
    $items = @(Get-ChildItem -Force -Path $configRoot)
    if ($items.Count -gt 0) {
        throw "$configRoot already exists and is not this Git repository. Move or back it up, then run the installer again."
    }
    git clone $repoUrl $configRoot
} else {
    git clone $repoUrl $configRoot
}

if ($LASTEXITCODE -ne 0) {
    throw "Could not clone the dotfiles repository."
}

Write-Step "Configuring XDG_CONFIG_HOME"
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $configRoot, "User")
$env:XDG_CONFIG_HOME = $configRoot

Write-Step "Connecting PowerShell profiles"
$documents = [Environment]::GetFolderPath("MyDocuments")
$profilePaths = @(
    (Join-Path $documents "PowerShell\Microsoft.PowerShell_profile.ps1"),
    (Join-Path $documents "WindowsPowerShell\Microsoft.PowerShell_profile.ps1")
) | Select-Object -Unique

foreach ($profilePath in $profilePaths) {
    Add-ProfileLoader -ProfilePath $profilePath
}

if (-not (Test-Path $profileSource)) {
    throw "PowerShell configuration was not found at $profileSource."
}

if (-not $SkipFont) {
    Write-Step "Installing Meslo Nerd Font"
    oh-my-posh font install meslo
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Nerd Font installation failed. Run 'oh-my-posh font install meslo' later."
    }
}

if (-not $SkipNeovimSync) {
    Write-Step "Synchronizing LazyVim plugins"
    nvim --headless "+Lazy! sync" +qa
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Neovim plugin sync did not finish. Open nvim once after restarting the terminal."
    }
}

Write-Step "Finished"
Write-Host "Close all terminal windows and open Windows Terminal with PowerShell 7." -ForegroundColor Green
Write-Host "Dotfiles: $configRoot"
