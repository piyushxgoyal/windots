# sym.ps1 - Symlink Manager
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Requires -Version 7

Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

# Destination (Windows real path) => Source (relative to repo root)
 $symlinks = [ordered]@{
    "$HOME\.gitconfig"                                     = ".gitconfig"
    "$PROFILE"                                             = "powershell\Profile.ps1"
    "$HOME\.config\starship.toml"                          = "starship\starship.toml"
    "$HOME\AppData\Local\btop"                             = "btop"
    "$HOME\AppData\Roaming\lazygit"                        = "lazygit"
    "$HOME\.config\mise"                                   = "mise"
    "$HOME\AppData\Roaming\mpv"                            = "mpv"
    "$HOME\AppData\Local\nvim"                             = "nvim"
    "$HOME\AppData\Roaming\VSCodium\User\settings.json"    = "VSCodium\User\settings.json"
    "$HOME\AppData\Roaming\VSCodium\User\keybindings.json" = "VSCodium\User\keybindings.json"
    "$HOME\AppData\Roaming\VSCodium\User\snippets"         = "VSCodium\User\snippets"
    "$HOME\.config\wezterm"                                = "wezterm"
    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "windowsterminal\settings.json"
}

function Remove-ExistingLink {
    param([Parameter(Mandatory)][string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) { return }

    $item = Get-Item -LiteralPath $Path -Force
    $isReparse = ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0

    if ($isReparse) {
        # It's a symlink/junction — delete the LINK only, never the target.
        if ($item.PSIsContainer) {
            [System.IO.Directory]::Delete($Path, $false)
        } else {
            [System.IO.File]::Delete($Path)
        }
    }
    else {
        # Real file/dir at destination — remove it.
        Remove-Item -LiteralPath $Path -Force -Recurse
    }
}

function New-Link {
    param(
        [Parameter(Mandatory)][string]$Link,
        [Parameter(Mandatory)][string]$Target
    )

    # Resolve source relative to repo root
    $sourcePath = Join-Path $PSScriptRoot $Target
    if (-not (Test-Path -LiteralPath $sourcePath)) {
        Write-Host "  [SKIP]  source missing: $sourcePath" -ForegroundColor DarkYellow
        return
    }
    $source = (Resolve-Path -LiteralPath $sourcePath).Path

    # Ensure parent dir of the link exists
    $parent = Split-Path -Parent $Link
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    Remove-ExistingLink -Path $Link

    try {
        New-Item -ItemType SymbolicLink -Path $Link -Target $source -Force | Out-Null
        Write-Host "  [link]  $Link  ->  $source" -ForegroundColor Green
    }
    catch {
        # Fallback: Junctions work for directories without admin/Developer Mode
        if (Test-Path -LiteralPath $source -PathType Container) {
            cmd /c mklink /J "$Link" "$source" | Out-Null
            Write-Host "  [junc]  $Link  ->  $source" -ForegroundColor Yellow
        }
        else {
            Write-Host "  [ERROR] $Link : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "==> Creating symbolic links..." -ForegroundColor Cyan
foreach ($kv in $symlinks.GetEnumerator()) {
    New-Link -Link $kv.Key -Target $kv.Value
}

Write-Host "==> Done." -ForegroundColor Cyan
