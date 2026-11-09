# 1-Click Installer for Universal Vibe Coding Standard on Another System
# Run this script in PowerShell on the target computer:
# powershell -ExecutionPolicy Bypass -File install-on-another-system.ps1

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Installing Universal Vibe Coding Standard              " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$TargetGeminiDir = Join-Path (Join-Path $HOME ".gemini") "config"
$TargetPluginsDir = Join-Path $TargetGeminiDir "plugins"
$PluginDest = Join-Path $TargetPluginsDir "vibe-coding-standard"
$ConfigFile = Join-Path $TargetGeminiDir "config.json"

# 1. Create Target Directories
if (-not (Test-Path $TargetPluginsDir)) {
    New-Item -ItemType Directory -Force -Path $TargetPluginsDir | Out-Null
}

# 2. Copy Plugin Directory
$SourceDir = $PSScriptRoot
Write-Host "[1/4] Copying plugin to: $PluginDest" -ForegroundColor Yellow
if (-not (Test-Path $PluginDest)) {
    New-Item -ItemType Directory -Force -Path $PluginDest | Out-Null
}
if ($SourceDir.TrimEnd('\/') -ne $PluginDest.TrimEnd('\/')) {
    Copy-Item -Path "$SourceDir\*" -Destination $PluginDest -Recurse -Force
} else {
    Write-Host "      Running directly from destination directory." -ForegroundColor Green
}

# 3. Enable Plugin in config.json
Write-Host "[2/4] Registering and enabling plugin in config.json..." -ForegroundColor Yellow
if (Test-Path $ConfigFile) {
    $configContent = Get-Content $ConfigFile -Raw
    if ($configContent -notmatch '"vibe-coding-standard"') {
        try {
            $json = $configContent | ConvertFrom-Json
            if (-not $json.plugins) {
                $json | Add-Member -MemberType NoteProperty -Name "plugins" -Value ([PSCustomObject]@{})
            }
            $json.plugins | Add-Member -MemberType NoteProperty -Name "vibe-coding-standard" -Value ([PSCustomObject]@{ enabled = $true })
            $json | ConvertTo-Json -Depth 20 | Set-Content $ConfigFile -Encoding UTF8
            Write-Host "      Updated existing config.json successfully." -ForegroundColor Green
        } catch {
            # Fallback simple string insertion if json parsing has custom schemas
            $configContent = $configContent -replace '("plugins"\s*:\s*\{)', "`$1`n    `"vibe-coding-standard`": { `"enabled`": true },"
            Set-Content $ConfigFile $configContent -Encoding UTF8
            Write-Host "      Injected plugin entry into config.json." -ForegroundColor Green
        }
    } else {
        Write-Host "      Plugin already declared in config.json." -ForegroundColor Green
    }
} else {
    $initialConfig = @"
{
  "plugins": {
    "vibe-coding-standard": {
      "enabled": true
    }
  }
}
"@
    Set-Content $ConfigFile $initialConfig -Encoding UTF8
    Write-Host "      Created new config.json." -ForegroundColor Green
}

# 4. Detect & Configure Claude (Claude Code CLI / Desktop)
Write-Host "[3/4] Checking for Claude Code / Claude Desktop setup..." -ForegroundColor Yellow
$TargetClaudeDir = Join-Path $HOME ".claude"
if (Test-Path $TargetClaudeDir) {
    $ClaudeGlobalRules = Join-Path $TargetClaudeDir "CLAUDE.md"
    $SourceClaudeRules = Join-Path $SourceDir "rules\CLAUDE.md"
    if (Test-Path $SourceClaudeRules) {
        if (-not (Test-Path $ClaudeGlobalRules)) {
            Copy-Item -Path $SourceClaudeRules -Destination $ClaudeGlobalRules -Force
            Write-Host "      Configured global Claude directives at ~/.claude/CLAUDE.md." -ForegroundColor Green
        } else {
            Write-Host "      Existing ~/.claude/CLAUDE.md detected (preserved)." -ForegroundColor Green
        }
    }
} else {
    Write-Host "      No global ~/.claude directory found (skipped). Project-level CLAUDE.md will be used." -ForegroundColor Gray
}

# 5. Completion
Write-Host "[4/4] Installation Complete!" -ForegroundColor Green
Write-Host "----------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Universal Vibe Coding Standard (v1.3.0) is active for Antigravity & Claude." -ForegroundColor White
Write-Host "Any current or new project will automatically enjoy:" -ForegroundColor White
Write-Host " - Dual Antigravity (AGENTS.md) & Claude (CLAUDE.md) interoperability" -ForegroundColor Gray
Write-Host " - Magic UI & Modern Design Tokens (React/Next.js & Laravel Blade)" -ForegroundColor Gray
Write-Host " - On-First-Chat safe non-destructive blueprint initialization" -ForegroundColor Gray
Write-Host " - Multi-conversation shared knowledge base synchronization" -ForegroundColor Gray
Write-Host " - Offline single-view visual HTML dashboard (docs/index.html)" -ForegroundColor Gray
Write-Host " - Portable in-project agent memory (.agents/)" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
