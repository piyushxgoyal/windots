Write-Host "Setting up symlinks..." -ForegroundColor Cyan

# PowerShell profile
$profileTarget = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$profileSource = "$HOME\dotfiles-win\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

Write-Host "Linking PowerShell profile..." -ForegroundColor Yellow

if (Test-Path $profileTarget) {
    Remove-Item $profileTarget -Force
    Write-Host "Removed existing profile" -ForegroundColor DarkGray
}

New-Item -ItemType SymbolicLink -Path $profileTarget -Target $profileSource | Out-Null
Write-Host "✔ PowerShell profile linked" -ForegroundColor Green


# mpv config
$mpvTarget = "$env:APPDATA\mpv"
$mpvSource = "$HOME\dotfiles-win\AppData\Roaming\mpv"

Write-Host "Linking mpv config..." -ForegroundColor Yellow

if (Test-Path $mpvTarget) {
    Remove-Item $mpvTarget -Recurse -Force
    Write-Host "Removed existing mpv config" -ForegroundColor DarkGray
}

New-Item -ItemType SymbolicLink -Path $mpvTarget -Target $mpvSource | Out-Null
Write-Host "✔ mpv config linked" -ForegroundColor Green


Write-Host "Done." -ForegroundColor Cyan
