# PowerToys CommandNotFound
if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound)
{
    Import-Module Microsoft.WinGet.CommandNotFound
}

# Chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile)
{
    Import-Module $ChocolateyProfile
}

# Starship
if (Get-Command starship -ErrorAction SilentlyContinue)
{
    Invoke-Expression (& starship init powershell)
}

# ALIASES
Set-Alias vim nvim

Set-Alias wi winget-install
Set-Alias ws winget-search
Set-Alias wua winget-upgrade-all
Set-Alias wu winget-upgrade
Set-Alias wrem winget-remove
Set-Alias wsh winget-show
Set-Alias wl winget-list

Set-Alias cdcode cd-code-folder
Set-Alias dsktp cd-desktop

Set-Alias ff fastfetch-windows

Set-Alias ls eza-ls
Set-Alias ll eza-list-long
Set-Alias l eza-list
Set-Alias lt eza-tree
Set-Alias lsd eza-list-directories

# FUNCTIONS

# ls = detailed view, include hidden files

function eza-ls
{
    eza -a `
        --icons `
        --header `
        --group-directories-first `
        @args
}


# l = normal listing, no hidden files
function eza-list
{
    eza `
        --icons `
        --group-directories-first `
        @args
}

# ll = full detailed view + git
function eza-list-long
{
    eza -la `
        --icons `
        --header `
        --group-directories-first `
        --git `
        --time-style=long-iso `
        @args
}

# lsd = directories only
function eza-list-directories
{
    eza -D `
        --icons `
        --group-directories-first `
        @args
}

# lt = tree
function eza-tree
{
    eza `
        --tree `
        --icons `
        @args
}

# Fastfetch
function fastfetch-windows
{
    fastfetch --logo windows @args
}

# Navigation
function cd-code-folder
{
    Set-Location "$HOME\Desktop\code"
}

function cd-desktop
{
    Set-Location "$HOME\Desktop"
}

# Winget Functions
function winget-search
{
    param(
        [string[]]$Arguments
    )
    & winget.exe search @Arguments
}

function winget-install
{
    param(
        [string[]]$Arguments
    )
    & winget.exe install @Arguments
}

function winget-upgrade-all
{
    & winget.exe upgrade --all
}

function winget-upgrade
{
    param(
        [string[]]$Arguments
    )
    & winget.exe upgrade @Arguments
}

function winget-remove
{
    param(
        [string[]]$Arguments
    )
    & winget.exe remove @Arguments
}

function winget-show
{
    param(
        [string[]]$Arguments
    )
    & winget.exe show @Arguments
}

function winget-list
{
    param(
        [string[]]$Arguments
    )
    & winget.exe list @Arguments
}
