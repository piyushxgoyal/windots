
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#STARSHIP
Invoke-Expression (&starship init powershell)
#zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#ALIAS
Set-Alias vim nvim
Set-Alias wi winget-install
Set-Alias ws winget-search
Set-Alias wua winget-upgrade-all
Set-Alias wu winget-upgrade
Set-Alias wrem winget-remove
Set-Alias wsh winget-show
Set-ALias wl winget-list
Set-Alias cdcode cd-code-folder
Set-Alias dsktp cd-desktop
Set-ALias ff fastfetch-windows

Set-Alias ll eza-list-long
Set-Alias l eza-list
Set-Alias lt eza-tree
Set-Alias lsd eza-list-directories


#Functions

# Dir Functions
function eza-list-long {
    eza -la --icons --header --group-directories-first --git --time-style=long-iso
}

function eza-list {
    eza --icons --group-directories-first
  }

function eza-tree {
    eza --tree --icons
}

function eza-list-directories {
    eza -D --icons
}

# fastfetch-windows
function fastfetch-windows {
    fastfetch --logo windows @args
}


function cd-code-folder {
    Set-Location "C:\Users\KIIT\Desktop\code"
}
function cd-desktop {
    Set-Location "C:\Users\KIIT\Desktop"
}
function winget-search {
    param(
        [string[]]$Arguments
    )
    & winget.exe search @Arguments
}
function winget-install {
    param(
        [string[]]$Arguments
    )
    & winget.exe install @Arguments
}
function winget-upgrade-all {
    param(
        [string[]]$Arguments
    )
    & winget.exe upgrade --all
}
function winget-upgrade {
    param(
        [string[]]$Arguments
    )
    & winget.exe upgrade @Arguments
}
function winget-remove {
    param(
        [string[]]$Arguments
    )
    & winget.exe remove @Arguments
}
function winget-show {
    param(
        [string[]]$Arguments
    )
    & winget.exe show @Arguments
}
function winget-list {
    param(
        [string[]]$Arguments
    )
    & winget.exe list @Arguments
}
