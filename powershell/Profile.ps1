# ===========================
# PowerShell Profile
# ===========================

# ---------------------------
# Cache Helper (Speeds up startup significantly)
# ---------------------------
 $psCacheDir = "$HOME\.ps_cache"
if (-not (Test-Path $psCacheDir)) {
    New-Item -ItemType Directory -Path $psCacheDir -Force | Out-Null
}

function Invoke-CachedInit {
    param(
        [string]$Name,
        [scriptblock]$Generator
    )
    $cacheFile = Join-Path $psCacheDir "$Name.ps1"
    
    # Generate cache if missing
    if (-not (Test-Path $cacheFile)) {
        & $Generator | Out-File $cacheFile -Encoding utf8
    }
    . $cacheFile
}

function Update-ProfileCache {
    Remove-Item "$psCacheDir\*.ps1" -Force -ErrorAction SilentlyContinue
    Write-Host "Profile cache cleared. Restart your shell to regenerate." -ForegroundColor Green
}

# ---------------------------
# PSReadLine
# ---------------------------
# PSReadLine is auto-loaded by PowerShell 7, so we skip the Get-Module check.
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Vim-style navigation in ListView
Set-PSReadLineKeyHandler -Chord Ctrl+j -Function NextSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+k -Function PreviousSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine

Set-PSReadLineOption -Colors @{
    Selection = "`e[7m"
}

# ---------------------------
# FZF (Official PSFzf Module)
# ---------------------------
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ---------------------------
# Starship (Cached Init)
# ---------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-CachedInit -Name "starship" -Generator { starship init powershell }
}

# ---------------------------
# zoxide (Cached Init)
# ---------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-CachedInit -Name "zoxide" -Generator { zoxide init powershell --cmd cd }
}

# ---------------------------
# mise (Full Activation)
# ---------------------------
if (Get-Command mise -ErrorAction SilentlyContinue) {
    mise activate pwsh | Out-String | Invoke-Expression
}

# ---------------------------
# Shared eza defaults
# ---------------------------
 $EzaDefaults = @(
    "--icons"
    "--group-directories-first"
)

# ===========================
# Plugins
# ===========================

# Optimized: Direct import is faster than Get-Module -ListAvailable
Import-Module git-aliases -ErrorAction SilentlyContinue -DisableNameChecking

# ===========================
# Aliases
# ===========================

# Tools
Set-Alias cat bat
Set-Alias vim nvim
Set-Alias btop btop4win
Set-Alias msvc Enter-MSVC

# Winget
Set-Alias wi winget-install
Set-Alias ws winget-search
Set-Alias wua winget-upgrade-all
Set-Alias wu winget-upgrade
Set-Alias wrem winget-remove
Set-Alias wsh winget-show
Set-Alias wl winget-list

# Navigation
Set-Alias cdcode cd-code-folder
Set-Alias dsktp cd-desktop

# Utilities
Set-Alias ff fastfetch-windows

# eza
Set-Alias l eza-list
Set-Alias la eza-ls
Set-Alias ls eza-ls
Set-Alias ll eza-list-long
Set-Alias lt eza-tree
Set-Alias lsd eza-list-directories

# ===========================
# Functions
# ===========================

# ---------------------------
# eza
# ---------------------------
function eza-ls { eza @EzaDefaults -a --header @args }
function eza-list { eza @EzaDefaults @args }
function eza-list-long { eza @EzaDefaults -la --header --git --time-style=long-iso @args }
function eza-list-directories { eza @EzaDefaults -D @args }
function eza-tree { eza @EzaDefaults --tree @args }

# ---------------------------
# Fastfetch
# ---------------------------
function fastfetch-windows { fastfetch --logo windows @args }

# ---------------------------
# Navigation
# ---------------------------
function cd-code-folder { Set-Location "$HOME\Desktop\code" }
function cd-desktop { Set-Location "$HOME\Desktop" }

# ---------------------------
# Winget
# ---------------------------
function winget-search { winget.exe search @args }
function winget-install { winget.exe install @args }
function winget-upgrade-all { winget.exe upgrade --all }
function winget-upgrade { winget.exe upgrade @args }
function winget-remove { winget.exe remove @args }
function winget-show { winget.exe show @args }
function winget-list { winget.exe list @args }

# ---------------------------
# WSL
# ---------------------------
function wslh { wsl -d archlinux --cd /home/zeroarch }

# ---------------------------
# GitHub CLI
# ---------------------------
function gh-private { gh repo create --private --source=. --remote=origin --push }
function gh-public { gh repo create --public --source=. --remote=origin --push }

# ---------------------------
# MSVC / Visual Studio Build Tools
# ---------------------------
# LAZY LOADED: Run 'msvc' manually when you need to compile C/C++.
function Enter-MSVC {
    if ($env:VSCMD_VER) { return }
    $vsDevCmd = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\2022\BuildTools\Common7\Tools\VsDevCmd.bat"
    if (-not (Test-Path $vsDevCmd)) { return }
    & $env:ComSpec /s /c "`"$vsDevCmd`" -no_logo -arch=amd64 -host_arch=amd64 && set" |
        ForEach-Object {
            if ($_ -match "=") {
                $name, $value = $_ -split "=", 2
                Set-Item -Path "Env:$name" -Value $value
            }
        }
}

# ===========================
# Command Completion Sound Notifications
# ===========================

# ---------------------------
# Configuration
# ---------------------------
$global:CommandSoundEnabled = $true
$global:CommandSoundThresholdSeconds = 10
$global:CommandSoundStartedAt = $null

# ---------------------------
# Toggle Helpers
# ---------------------------
function Enable-CommandSound {
    $global:CommandSoundEnabled = $true
    Write-Host "Command sounds: ON" -ForegroundColor Green
}

function Disable-CommandSound {
    $global:CommandSoundEnabled = $false
    Write-Host "Command sounds: OFF" -ForegroundColor Yellow
}

function Get-CommandSoundStatus {
    [pscustomobject]@{
        Enabled          = $global:CommandSoundEnabled
        ThresholdSeconds = $global:CommandSoundThresholdSeconds
    }
}

# ---------------------------
# Command Start Detection
# ---------------------------
# PSReadLine calls this before executing an accepted command.
Set-PSReadLineOption -CommandValidationHandler {
    param(
        [System.Management.Automation.Language.CommandAst]$CommandAst
    )

    $global:CommandSoundStartedAt =
        [System.Diagnostics.Stopwatch]::GetTimestamp()
}

# ---------------------------
# Preserve Existing Prompt
# ---------------------------
# This runs after Starship initialization, preserving its prompt
# implementation instead of replacing it with a plain prompt.
if (-not $global:CommandSoundOriginalPrompt) {
    $global:CommandSoundOriginalPrompt = $function:prompt
}

# ---------------------------
# Completion Detection
# ---------------------------
function global:prompt {
    # Capture the previous command's status immediately.
    $commandSucceeded = $?

    $startedAt = $global:CommandSoundStartedAt
    $global:CommandSoundStartedAt = $null

    $elapsed = 0

    if ($null -ne $startedAt) {
        $elapsed = (
            [System.Diagnostics.Stopwatch]::GetTimestamp() - $startedAt
        ) / [System.Diagnostics.Stopwatch]::Frequency
    }

    # Generate Starship's existing prompt.
    $promptText = & $global:CommandSoundOriginalPrompt

    # Notify only for eligible long-running commands.
    if (
        $global:CommandSoundEnabled -and
        $null -ne $startedAt -and
        $elapsed -ge $global:CommandSoundThresholdSeconds
    ) {
        try {
            if ($commandSucceeded) {
                # Success: one high tone.
                [Console]::Beep(1000, 180)
            }
            else {
                # Failure: two low tones.
                [Console]::Beep(500, 180)
                [Console]::Beep(500, 180)
            }
        }
        catch {
            # Audio failure must not prevent the prompt from rendering.
        }
    }

    $promptText
}
