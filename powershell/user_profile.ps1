# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

Import-Module posh-git
$omp_config = Join-Path $PSScriptRoot ".\takuya.omp.json"
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
#Set-PSReadLineKeyHandler -Key 'Ctrl+f' -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key 'Ctrl+h' -Function BackwardChar
Set-PSReadLineKeyHandler -Key 'Ctrl+l' -Function ForwardChar
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

# Utilities
# Generate compile_commands.json for the IAR project in .\EWARM
function ccdb {
  param(
    [string]$Project,
    [string]$Configuration = "CM7"
  )

  $iarCandidates = @(
    Get-Item "C:\iar\ewarm-*\common\bin\iarbuild.exe" -ErrorAction SilentlyContinue
    Get-Item "C:\Program Files\IAR Systems\Embedded Workbench*\common\bin\IarBuild.exe" -ErrorAction SilentlyContinue
  ) | Sort-Object LastWriteTime -Descending

  $iarbuild = $iarCandidates | Select-Object -First 1
  if (-not $iarbuild) {
    Write-Error "iarbuild.exe was not found."
    return
  }

  if ($Project) {
    $projectFile = Get-Item $Project -ErrorAction SilentlyContinue
  } else {
    $ewarmDirectory = Join-Path (Get-Location) "EWARM"
    $projects = @(Get-ChildItem $ewarmDirectory -Filter "*.ewp" -File -ErrorAction SilentlyContinue)

    if ($projects.Count -gt 1) {
      $preferredProjects = @($projects | Where-Object { $_.Name -match " - 850\.ewp$" })

      if ($preferredProjects.Count -eq 1) {
        $projectFile = $preferredProjects[0]
        Write-Host "Selected IAR 8.50 project: $($projectFile.Name)"
      } else {
        Write-Host "Multiple IAR projects were found:"
        $projects | ForEach-Object { Write-Host "  $($_.FullName)" }
        Write-Host "Run: ccdb -Project '<path-to-ewp>'"
        return
      }
    } else {
      $projectFile = $projects | Select-Object -First 1
    }
  }

  if (-not $projectFile) {
    Write-Error "An IAR .ewp project was not found. Run this command from the project root or specify -Project."
    return
  }

  & $iarbuild.FullName $projectFile.FullName -jsondb $Configuration -output compile_commands.json
}

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

