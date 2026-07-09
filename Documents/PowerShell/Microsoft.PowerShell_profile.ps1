# ===========================
# PowerShell Profile
# ===========================

# ---------------------------
# PowerToys Command Not Found
# ---------------------------
if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound)
{
    Import-Module Microsoft.WinGet.CommandNotFound
}

# ---------------------------
# PSReadLine
# ---------------------------
if (Get-Module -ListAvailable -Name PSReadLine)
{
    Import-Module PSReadLine

    # Predictions
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView

    # Vim-style navigation in ListView
    Set-PSReadLineKeyHandler -Chord Ctrl+j -Function NextSuggestion
    Set-PSReadLineKeyHandler -Chord Ctrl+k -Function PreviousSuggestion

    # History
    Set-PSReadLineOption -HistoryNoDuplicates

    # Disable terminal bell
    Set-PSReadLineOption -BellStyle None

    # Delete previous word
    Set-PSReadLineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord

    # Better Tab completion
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

    # History search by current input
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

    # Set-PSReadLineOption -Colors @{
    #    Selection = "`e[7m"
    # }
}

# ---------------------------
# FZF
# ---------------------------

$env:FZF_DEFAULT_OPTS = @"
--height=45%
--layout=reverse
--border=rounded
--cycle
--info=inline-right
--prompt=❯
--pointer=▶
--marker=✓
--preview-window=hidden
"@

$env:FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND

# ---------------------------
# PSFzf
# ---------------------------
if (Get-Module -ListAvailable -Name PSFzf)
{
    Import-Module PSFzf

    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
    Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
}

# ---------------------------
# Carapace
# ---------------------------
if (Get-Command carapace -ErrorAction SilentlyContinue)
{
    $env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

    carapace _carapace powershell |
        Out-String |
        Invoke-Expression
}

# ---------------------------
# Starship
# ---------------------------
if (Get-Command starship -ErrorAction SilentlyContinue)
{
    Invoke-Expression (& starship init powershell)
}

# ---------------------------
# zoxide
# ---------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue)
{
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}

# ---------------------------
# Shared eza defaults
# ---------------------------
$EzaDefaults = @(
    "--icons"
    "--group-directories-first"
)

# ===========================
# ALIASES
# ===========================


# tools
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
# FUNCTIONS
# ===========================

# ---------- eza ----------

function eza-ls
{
    eza @EzaDefaults -a --header @args
}

function eza-list
{
    eza @EzaDefaults @args
}

function eza-list-long
{
    eza @EzaDefaults -la --header --git --time-style=long-iso @args
}

function eza-list-directories
{
    eza @EzaDefaults -D @args
}

function eza-tree
{
    eza @EzaDefaults --tree @args
}

# ---------- Fastfetch ----------

function fastfetch-windows
{
    fastfetch --logo windows @args
}

# ---------- Navigation ----------

function cd-code-folder
{
    Set-Location "$HOME\Desktop\code"
}

function cd-desktop
{
    Set-Location "$HOME\Desktop"
}

# ---------- Winget ----------

function winget-search
{
    param([string[]]$Arguments)
    & winget.exe search @Arguments
}

function winget-install
{
    param([string[]]$Arguments)
    & winget.exe install @Arguments
}

function winget-upgrade-all
{
    & winget.exe upgrade --all
}

function winget-upgrade
{
    param([string[]]$Arguments)
    & winget.exe upgrade @Arguments
}

function winget-remove
{
    param([string[]]$Arguments)
    & winget.exe remove @Arguments
}

function winget-show
{
    param([string[]]$Arguments)
    & winget.exe show @Arguments
}

function winget-list
{
    param([string[]]$Arguments)
    & winget.exe list @Arguments
}

# ---------- Java ----------

function java17
{
    $env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
    $env:Path = "$env:JAVA_HOME\bin;" + (($env:Path -split ';') | Where-Object { $_ -notmatch 'Java\\jdk-' } | Join-String -Separator ';')
    java -version
}

function java21
{
    $env:JAVA_HOME = "C:\Program Files\Java\jdk-21"
    $env:Path = "$env:JAVA_HOME\bin;" + (($env:Path -split ';') | Where-Object { $_ -notmatch 'Java\\jdk-' } | Join-String -Separator ';')
    java -version
}

# ---------- WSL -----------

function wslh {
    wsl -d archlinux --cd /home/zeroarch
}
