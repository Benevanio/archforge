# install.ps1
# Installs ArchForge on Windows (PowerShell).
#
# ArchForge is a Bash CLI, so it runs through Git Bash (bundled with
# Git for Windows). This script:
#   1. Locates bash.exe (Git for Windows).
#   2. Creates an 'archforge.cmd' shim in a user-writable directory
#      so 'archforge' works from PowerShell and cmd.exe.
#   3. Adds that directory to the user's PATH if needed.
#
# It never overwrites a file it does not manage.

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceBin = Join-Path $ScriptDir 'bin\archforge'

if (-not (Test-Path $SourceBin)) {
    Write-Error "Error: '$SourceBin' not found. Run this script from the ArchForge repository root."
    exit 1
}

# ---------------------------------------------------------------------------
# 1. Locate bash.exe (Git for Windows)
# ---------------------------------------------------------------------------
$BashExe = $null

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if ($gitCmd) {
    # e.g. C:\Program Files\Git\cmd\git.exe -> C:\Program Files\Git\bin\bash.exe
    $gitRoot = Split-Path -Parent (Split-Path -Parent $gitCmd.Source)
    $candidate = Join-Path $gitRoot 'bin\bash.exe'
    if (Test-Path $candidate) { $BashExe = $candidate }
}

if (-not $BashExe) {
    foreach ($candidate in @(
        "$env:ProgramFiles\Git\bin\bash.exe",
        "${env:ProgramFiles(x86)}\Git\bin\bash.exe",
        "$env:LocalAppData\Programs\Git\bin\bash.exe"
    )) {
        if ($candidate -and (Test-Path $candidate)) { $BashExe = $candidate; break }
    }
}

if (-not $BashExe) {
    Write-Error "Error: Git Bash (bash.exe) not found. ArchForge requires Git for Windows: https://git-scm.com/download/win"
    exit 1
}

Write-Host "Found Git Bash: $BashExe"

# ---------------------------------------------------------------------------
# 2. Create the 'archforge.cmd' shim
# ---------------------------------------------------------------------------
$InstallDir = Join-Path $env:LocalAppData 'ArchForge\bin'
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

$Target = Join-Path $InstallDir 'archforge.cmd'

if ((Test-Path $Target) -and -not (Select-String -Path $Target -Pattern 'ArchForge launcher shim' -Quiet)) {
    Write-Error "Error: '$Target' already exists and is not a managed ArchForge install. Refusing to overwrite it."
    exit 1
}

# Git Bash understands Windows paths for the script argument.
$ShimContent = @"
@echo off
rem ArchForge launcher shim
"$BashExe" "$SourceBin" %*
"@

Set-Content -Path $Target -Value $ShimContent -Encoding Ascii
Write-Host "Installed: $Target -> $SourceBin"

# ---------------------------------------------------------------------------
# 3. Ensure the install directory is on the user's PATH
# ---------------------------------------------------------------------------
$UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($UserPath -split ';') -notcontains $InstallDir) {
    [Environment]::SetEnvironmentVariable('Path', "$UserPath;$InstallDir", 'User')
    $env:Path = "$env:Path;$InstallDir"
    Write-Host "Added '$InstallDir' to your user PATH."
    Write-Host "Open a new terminal for the change to take effect everywhere."
} else {
    Write-Host "'$InstallDir' is already on your PATH."
}

Write-Host ""
Write-Host "Run 'archforge --help' to get started."
