# 1-Click Magic UI Setup Helper for React / Next.js / Vite / Laravel Inertia
# Usage: powershell -ExecutionPolicy Bypass -File setup-magic-ui.ps1 [-ProjectPath "C:\path\to\project"]

param (
    [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ProjectPath)) {
    Write-Host "[!] Target directory does not exist: $ProjectPath" -ForegroundColor Red
    exit 1
}

$ResolvedPath = (Resolve-Path -LiteralPath $ProjectPath).Path
Write-Host ">>> Initializing Magic UI & Modern Component Primitives for: $ResolvedPath" -ForegroundColor Cyan

# 1. Check Node & Package Manager Prerequisites
if (-not (Get-Command "npx" -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Node.js and npx are required but were not found on PATH." -ForegroundColor Red
    Write-Host "    Please install Node.js (https://nodejs.org) and try again." -ForegroundColor Yellow
    exit 1
}

$PackageJson = Join-Path $ResolvedPath "package.json"
if (-not (Test-Path -LiteralPath $PackageJson)) {
    Write-Host "[!] No package.json found in: $ResolvedPath" -ForegroundColor Red
    Write-Host "    Make sure this project is a Node / React / Next.js / Laravel project." -ForegroundColor Yellow
    exit 1
}

Push-Location $ResolvedPath

try {
    # 2. Check for shadcn/ui components.json
    $ComponentsJson = Join-Path $ResolvedPath "components.json"
    if (-not (Test-Path $ComponentsJson)) {
        Write-Host "[1/3] Initializing shadcn/ui (prerequisite for Magic UI)..." -ForegroundColor Yellow
        cmd.exe /c "npx --yes shadcn@latest init -d"
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!] Note: shadcn init returned code $LASTEXITCODE. Continuing..." -ForegroundColor Gray
        }
    } else {
        Write-Host "[1/3] shadcn/ui components.json already initialized." -ForegroundColor Green
    }

    # 3. Install Core Magic UI Components
    Write-Host "[2/3] Installing foundational Magic UI components (Bento Grid, Magic Card, Marquee, Blur Fade, Shiny Button)..." -ForegroundColor Yellow
    
    $CoreComponents = @(
        "@magicui/bento-grid",
        "@magicui/magic-card",
        "@magicui/marquee",
        "@magicui/blur-fade",
        "@magicui/shiny-button"
    )

    foreach ($comp in $CoreComponents) {
        Write-Host "   -> Adding $comp..." -ForegroundColor Cyan
        cmd.exe /c "npx --yes shadcn@latest add $comp -y"
    }

    # 4. Success summary
    Write-Host "[3/3] Magic UI Suite Successfully Initialized!" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "Components ready in your components/ui directory:" -ForegroundColor White
    Write-Host " - Bento Grid (Feature layouts)" -ForegroundColor Gray
    Write-Host " - Magic Card (Glowing interactive cards)" -ForegroundColor Gray
    Write-Host " - Marquee (Infinite scroll for logos / reviews)" -ForegroundColor Gray
    Write-Host " - Blur Fade (Cinematic section & text reveal)" -ForegroundColor Gray
    Write-Host " - Shiny Button (Animated CTA interaction)" -ForegroundColor Gray
    Write-Host "==========================================================" -ForegroundColor Cyan
} finally {
    Pop-Location
}
