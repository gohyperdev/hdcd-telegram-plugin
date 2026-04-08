# Download hdcd-telegram binary from GitHub Releases (Windows).
# Binary is cached in CLAUDE_PLUGIN_DATA so it survives plugin updates.

$ErrorActionPreference = "Stop"

$Version = "v0.1.1"
$Repo = "gohyperdev/hdcd-telegram"
$DataDir = if ($env:CLAUDE_PLUGIN_DATA) { $env:CLAUDE_PLUGIN_DATA } else { "$env:USERPROFILE\.claude\plugins\data\hdcd-telegram" }
$Binary = "$DataDir\hdcd-telegram.exe"
$VersionFile = "$DataDir\.version"

# Skip if already installed at correct version
if ((Test-Path $Binary) -and (Test-Path $VersionFile) -and ((Get-Content $VersionFile) -eq $Version)) {
    exit 0
}

# Detect architecture
$Arch = if ([Environment]::Is64BitOperatingSystem) { "amd64" } else { "386" }

$ArchiveName = "hdcd-telegram-${Version}-windows-${Arch}.zip"
$DownloadUrl = "https://github.com/${Repo}/releases/download/${Version}/${ArchiveName}"

New-Item -ItemType Directory -Path $DataDir -Force | Out-Null
$TmpDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP "hdcd-telegram-setup-$(Get-Random)")

try {
    Write-Host "Downloading hdcd-telegram ${Version} for windows-${Arch}..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $DownloadUrl -OutFile "$TmpDir\archive.zip" -UseBasicParsing

    Expand-Archive -Path "$TmpDir\archive.zip" -DestinationPath "$TmpDir\extracted" -Force

    $FoundBinary = Get-ChildItem -Path "$TmpDir\extracted" -Filter "hdcd-telegram.exe" -Recurse | Select-Object -First 1
    if (-not $FoundBinary) {
        throw "Binary not found in archive"
    }

    Copy-Item $FoundBinary.FullName $Binary -Force
    Set-Content -Path $VersionFile -Value $Version

    Write-Host "hdcd-telegram ${Version} installed to ${Binary}" -ForegroundColor Green
}
finally {
    Remove-Item -Path $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
}
