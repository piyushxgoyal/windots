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

    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle InlineView
    Set-PSReadLineOption -EditMode Windows
}

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
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
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

Set-Alias vim nvim

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

# tools
Set-Alias cat bat

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


