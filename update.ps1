# Sattva Reel Studio — one-command deploy.
# Bumps the service-worker cache version (so the installed app refreshes),
# then commits everything and pushes to GitHub Pages.
#
# Usage:
#   .\update.ps1                 # default commit message
#   .\update.ps1 "what changed"  # custom commit message

param([string]$Message = "Update Sattva Reel Studio")

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# --- Bump SW cache: sattva-reel-vN -> v(N+1) ---
$swPath = Join-Path $PSScriptRoot "sw.js"
$sw = Get-Content $swPath -Raw
$m = [regex]::Match($sw, 'sattva-reel-v(\d+)')
if (-not $m.Success) { Write-Error "Couldn't find cache version in sw.js"; exit 1 }
$next = [int]$m.Groups[1].Value + 1
$sw = [regex]::Replace($sw, 'sattva-reel-v\d+', "sattva-reel-v$next")
[System.IO.File]::WriteAllText($swPath, $sw)
Write-Host "Bumped service-worker cache -> sattva-reel-v$next" -ForegroundColor Green

# --- Commit + push ---
git add -A
git commit -m $Message
git push origin main

Write-Host ""
Write-Host "Pushed. Wait ~1 min for GitHub Pages to rebuild," -ForegroundColor Cyan
Write-Host "then open the app on your phone TWICE to pick up the update." -ForegroundColor Cyan
