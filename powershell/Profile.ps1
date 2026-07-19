# ===========================
# PowerShell Profile
# ===========================

# ---------------------------
# PowerToys Command Not Found
# ---------------------------
if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound) {
    Import-Module Microsoft.WinGet.CommandNotFound
}

# ---------------------------
# PSReadLine
# ---------------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine

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

    Set-PSReadLineOption -Colors @{
        Selection = "`e[7m"
    }
}

# ---------------------------
# FZF (Official PSFzf Module)
# ---------------------------
if (Get-Module -ListAvailable -Name PSFzf) {
    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ---------------------------
# Carapace
# ---------------------------
if (Get-Command carapace -ErrorAction SilentlyContinue) {
    $env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
    carapace _carapace powershell | Out-String | Invoke-Expression
}

# ---------------------------
# Starship
# ---------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}

# ---------------------------
# zoxide
# ---------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell --cmd cd | Out-String)
}

# ---------------------------
# mise
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

if (Get-Module -ListAvailable -Name git-aliases) {
    Import-Module git-aliases -DisableNameChecking
}

# ===========================
# Aliases
# ===========================

# Tools
Set-Alias cat bat
Set-Alias vim nvim
Set-Alias btop btop4win

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
