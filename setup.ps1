# ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ████████╗███████╗
# ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
# ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║   ██║   ███████╗
# ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║   ██║   ╚════██║
# ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝   ██║   ███████║
#  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
# Setup.ps1 - Windows Bootstrap
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Requires -RunAsAdministrator
#Requires -Version 7

Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

# ── Winget dependencies ─────────────────────────────────────────────────────
 $wingetDeps = @(
    # Core CLI Tools
    "ajeetdsouza.zoxide"            # zoxide
    "aristocratos.btop4win"         # btop
    "astral-sh.uv"                  # uv
    "BurntSushi.ripgrep.MSVC"       # ripgrep
    "dandavison.delta"              # delta
    "eza-community.eza"             # eza
    "fastfetch-cli.fastfetch"       # fastfetch
    "gerardog.gsudo"                # gsudo
    "git.git"                       # git
    "github.cli"                    # gh
    "jqlang.jq"                     # jq
    "jdx.mise"                      # mise (handles node, python, etc.)
    "JesseDuffield.lazygit"         # lazygit
    "junegunn.fzf"                  # fzf
    "MikeFarah.yq"                  # yq
    "Microsoft.PowerShell"          # pwsh
    "Neovim.Neovim"                 # nvim
    "sharkdp.bat"                   # bat
    "sharkdp.fd"                    # fd
    "shinchiro.mpv"                 # mpv
    "SQLite.SQLite"                 # SQLite
    "starship.starship"             # starship
    "sxyazi.yazi"                   # yazi
    "tldr-pages.tlrc"               # tlrc

    # GUI Applications & Desktop Tools
    "amir1376.ABDownloadManager"    # AB Download Manager
    "Brave.Brave"                   # Brave Browser
    "Bruno.Bruno"                   # Bruno API Client
    "cowboy8625.rusty-rain"         # Rusty Rain
    "Daum.PotPlayer"                # PotPlayer
    "DBeaver.DBeaver.Community"     # DBeaver
    "Docker.DockerDesktop"          # Docker Desktop
    "Doppler.doppler"               # Doppler
    "geeksoftwareGmbH.PDF24Creator" # PDF24 Creator
    "M2Team.NanaZip"                # NanaZip
    "MarkText.MarkText"             # MarkText
    "Microsoft.PowerToys"           # PowerToys
    "Microsoft.WSL"                 # WSL
    "Obsidian.Obsidian"             # Obsidian
    "Proton.ProtonVPN"              # Proton VPN
    "Proton.ProtonPass"             # Proton PASS
    "REALiX.HWiNFO"                 # HWiNFO
    "SumatraPDF.SumatraPDF"         # Sumatra PDF
    "VSCodium.VSCodium"             # VSCodium
    "wez.wezterm"                   # WezTerm
    "ZedIndustries.Zed"             # Zed
    "Zen-Team.Zen-Browser"          # Zen Browser

    # Microsoft Store Apps (Winget handles these via msstore source)
    "9PFHDD62MXS1"                  # Apple Music
    "9N7JSXC1SJK6"                  # Blip App
    "9PFXXSHC64H3"                  # Raycast
)

Write-Host "==> Installing missing Winget dependencies..." -ForegroundColor Cyan
 $installedWinget = winget list | Out-String
foreach ($dep in $wingetDeps) {
    if ($installedWinget -notmatch [regex]::Escape($dep)) {
        winget install --id $dep --accept-source-agreements --accept-package-agreements
    }
}

# Refresh PATH for the current session so newly installed tools are visible immediately
 $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

# ── PowerShell Modules ──────────────────────────────────────────────────────
Write-Host "==> Installing missing PowerShell modules..." -ForegroundColor Cyan
 $psModules = @(
    "PSFzf"
    "git-aliases"
)

# Ensure PSGallery is trusted to avoid prompts
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

foreach ($psModule in $psModules) {
    if (!(Get-Module -ListAvailable -Name $psModule)) {
        Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser -SkipPublisherCheck
    }
}

# ── Hand off to sym.ps1 ─────────────────────────────────────────────────────
Write-Host "==> Creating symbolic links via sym.ps1..." -ForegroundColor Cyan
& "$PSScriptRoot\sym.ps1"

Write-Host "`n==> Done. Restart your shell so PATH updates take full effect." -ForegroundColor Green
