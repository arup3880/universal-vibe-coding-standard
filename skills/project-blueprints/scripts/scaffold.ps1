# Universal Project Blueprint Scaffolder (2026 Unified Edition)
# Usage: powershell -ExecutionPolicy Bypass -File scaffold.ps1 [-ProjectPath "C:\path\to\project"]

param (
    [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ProjectPath)) {
    Write-Host "[!] Target directory does not exist: $ProjectPath" -ForegroundColor Red
    exit 1
}

$ResolvedPath = (Resolve-Path -LiteralPath $ProjectPath).Path
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Write-Host ">>> Universal Vibe Setup & Upgrade for: $ResolvedPath" -ForegroundColor Cyan

# 1. Check Directory and Environment
$DocsDir = Join-Path $ResolvedPath "docs"
$AgentsDir = Join-Path $ResolvedPath ".agents"
$KBFile = Join-Path $DocsDir "KNOWLEDGE_BASE.md"

$IsUpgrade = $false
if (Test-Path $KBFile) {
    $IsUpgrade = $true
    Write-Host "[*] Existing living blueprints detected. Running in non-destructive audit & upgrade mode..." -ForegroundColor Yellow
}

# 2. Inspect Project Environment, Stack & Domain
$ProjectName = (Split-Path $ResolvedPath -Leaf)
$DetectedDomain = "General Software Project"
$DetectedStack = "Universal / Cross-Platform"

if ((Test-Path (Join-Path $ResolvedPath "freqtrade")) -or (Test-Path (Join-Path $ResolvedPath "user_data\strategies")) -or ($ProjectName -like "*freqtrade*") -or ($ProjectName -like "*trading*")) {
    $DetectedDomain = "Algorithmic Trading & Quantitative Strategy"
    $DetectedStack = "Python / Freqtrade Engine"
} elseif (($ProjectName -like "*video*") -or ($ProjectName -like "*youtube*") -or (Test-Path (Join-Path $ResolvedPath "ffmpeg*"))) {
    $DetectedDomain = "Media Generation & Video Pipeline"
    $DetectedStack = "Python / Multimedia & Video Processing"
} elseif (Test-Path (Join-Path $ResolvedPath "artisan")) {
    $DetectedDomain = "Web Application"
    $DetectedStack = "Laravel PHP Framework"
} elseif (Test-Path (Join-Path $ResolvedPath "composer.json")) {
    $DetectedDomain = "Backend Application"
    $DetectedStack = "PHP Application"
} elseif (Test-Path (Join-Path $ResolvedPath "package.json")) {
    $DetectedDomain = "Web / JavaScript Application"
    $DetectedStack = "Node.js / JavaScript"
} elseif ((Test-Path (Join-Path $ResolvedPath "requirements.txt")) -or (Test-Path (Join-Path $ResolvedPath "pyproject.toml")) -or (Test-Path (Join-Path $ResolvedPath "manage.py"))) {
    $DetectedDomain = "Data / Python System"
    $DetectedStack = "Python Application"
} elseif (Test-Path (Join-Path $ResolvedPath "Cargo.toml")) {
    $DetectedDomain = "Systems Application"
    $DetectedStack = "Rust"
} elseif (Test-Path (Join-Path $ResolvedPath "go.mod")) {
    $DetectedDomain = "Cloud / Microservice"
    $DetectedStack = "Go (Golang)"
}

# 3. Create Standard Directories (Non-destructive)
$DirsToCreate = @(
    $DocsDir,
    (Join-Path $AgentsDir "memory"),
    (Join-Path $AgentsDir "rules"),
    (Join-Path $AgentsDir "skills")
)
foreach ($d in $DirsToCreate) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
    }
}

$NowDate = Get-Date -Format "yyyy-MM-dd HH:mm"
$MonthYear = Get-Date -Format "MMMM yyyy"

# 4. Generate .agents/memory/context.md
$ContextFile = Join-Path $AgentsDir "memory\context.md"
if (-not (Test-Path $ContextFile)) {
    $cTemplate = @'
# {{PROJECT_NAME}} — Agent Working Memory & Context

- **Domain**: {{DOMAIN}}
- **Tech Stack**: {{STACK}}
- **Initialization Date**: {{DATE}}
- **Active Focus**: Initial project onboarding & specification alignment.

## Core Architectural Guardrails
1. **Multi-Conversation Synchronization**: Always read and update `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md`.
2. **Data & State Invariants**: Follow data contracts and schemas defined in `docs/ERD.md` / `docs/ARCHITECTURE.md`.
3. **Preserve Code Integrity**: Never delete existing core modules, strategies, or helper methods without explicit confirmation.
'@
    $cContent = $cTemplate.Replace("{{PROJECT_NAME}}", $ProjectName).Replace("{{DOMAIN}}", $DetectedDomain).Replace("{{STACK}}", $DetectedStack).Replace("{{DATE}}", $NowDate)
    [System.IO.File]::WriteAllText($ContextFile, $cContent, $utf8NoBom)
    Write-Host "[+] Created .agents/memory/context.md" -ForegroundColor Green
}

# 5. Generate docs/KNOWLEDGE_BASE.md
if (-not (Test-Path $KBFile)) {
    $kbTemplate = @'
# {{PROJECT_NAME}} — Central Project Knowledge Base
**Repository Root**: `{{PATH}}`  
**Domain**: {{DOMAIN}}  
**Tech Stack**: {{STACK}}  
**Last Updated**: {{DATE}}

---

## 1. Executive Architecture Overview
- **System Purpose**: Core engine and workflows for {{PROJECT_NAME}}.
- **Execution Modes**: Standalone CLI / Batch Service / Background Worker / API.

---

## 2. Environment & Configuration Topology
| Configuration Key / Service | Target / Provider | Purpose | Secret Handling |
| :--- | :--- | :--- | :--- |
| **App Environment** | Local / Server | Runtime execution | [Configured in .env / settings.json] |
| **Data / State Store** | File / DB / Cache | State & transaction persistence | [Refer to .env -> CREDENTIAL_KEY] |

---

## 3. Core Modules & Subsystems
- **Core Engine**: Main business logic, pipeline execution, or algorithmic engine.
- **Data Ingestion / Input**: Source data adapters, API connectors, or file parsers.
- **Output / Reporting**: Execution logs, generated artifacts, media renders, or export files.

---

## 4. Maintenance Protocol for AI Agents
Whenever you create or modify a pipeline, strategy, data model, or API integration in any conversation, update this file and `docs/ERD.md` / `docs/ARCHITECTURE.md` / `docs/MEMORY.md`.
'@
    $kbContent = $kbTemplate.Replace("{{PROJECT_NAME}}", $ProjectName).Replace("{{PATH}}", $ResolvedPath).Replace("{{DOMAIN}}", $DetectedDomain).Replace("{{STACK}}", $DetectedStack).Replace("{{DATE}}", $MonthYear)
    [System.IO.File]::WriteAllText($KBFile, $kbContent, $utf8NoBom)
    Write-Host "[+] Created docs/KNOWLEDGE_BASE.md" -ForegroundColor Green
}

# 6. Generate or Upgrade docs/PRD.md (Best-Suited Standard, Upgrading Legacy SRS.md)
$PRDFile = Join-Path $DocsDir "PRD.md"
$LegacySRSFile = Join-Path $DocsDir "SRS.md"

if (-not (Test-Path $PRDFile)) {
    if (Test-Path $LegacySRSFile) {
        # Gracefully upgrade existing SRS.md into PRD.md
        $srsRaw = [System.IO.File]::ReadAllText($LegacySRSFile, $utf8NoBom)
        $prdHeader = "# Product Requirements Document (PRD): $ProjectName`n`n> Upgraded from legacy SRS.md with full backward compatibility.`n`n"
        $upgradedPRD = $srsRaw -replace '^#\s+Software Requirements Specification.*', $prdHeader
        [System.IO.File]::WriteAllText($PRDFile, $upgradedPRD, $utf8NoBom)
        Write-Host "[+] Upgraded docs/SRS.md -> docs/PRD.md" -ForegroundColor Green
    } else {
        $prdTemplate = @'
# Product Requirements Document (PRD): {{PROJECT_NAME}}

## 1. Executive Summary & Objective
- **Problem / Goal**: Describe what {{PROJECT_NAME}} solves or automates.
- **Target Audience / Consumer**: Users, automated schedulers, or downstream consumer systems.
- **Success Criteria**: Verifiable metrics and delivery milestones.

## 2. System Inputs, Processing & Outputs
| Stage | Component / Stream | Description |
| :--- | :--- | :--- |
| **Input** | Data Feeds / User Config | Source data, API streams, media assets, or CLI parameters. |
| **Processing** | Engine / Pipeline | Transformation, analysis, algorithmic evaluation, or rendering. |
| **Output** | Artifacts / Actions | Persisted state, generated media, trade signals, or reports. |

## 3. Scope Matrix & Functional Requirements (MoSCoW)
| ID | Subsystem | Requirement Description | Priority (MoSCoW) | Status |
| :--- | :--- | :--- | :--- | :--- |
| **FR-01** | Core | Engine initialization and configuration parsing | Must Have | ✅ Implemented |
| **FR-02** | Core | Primary processing pipeline / execution loop | Must Have | 🟡 In-Progress |
| **FR-03** | Telemetry | Logging, error alerting, and health metrics | Should Have | ⏳ Backlog |

## 4. Non-Functional Budgets & Constraints
- **Performance & Latency**: Sub-second execution or designated throughput limits.
- **Security Guardrails**: Zero plain-text API secrets; credentials stored exclusively in `.env`.
- **Runtime Environment**: {{STACK}} on host operating system.
'@
        $prdContent = $prdTemplate.Replace("{{PROJECT_NAME}}", $ProjectName).Replace("{{STACK}}", $DetectedStack)
        [System.IO.File]::WriteAllText($PRDFile, $prdContent, $utf8NoBom)
        Write-Host "[+] Created docs/PRD.md" -ForegroundColor Green
    }
}

# 7. Generate docs/ERD.md
$ERDFile = Join-Path $DocsDir "ERD.md"
if (-not (Test-Path $ERDFile)) {
    $erdTemplate = @'
# Data & State Models: {{PROJECT_NAME}}

```mermaid
erDiagram
    CONFIG ||--o{ RUNTIME_EXECUTION : configures
    RUNTIME_EXECUTION ||--o{ LOG_ENTRIES : produces

    CONFIG {
        string config_id PK
        string environment
        string settings_hash
        datetime created_at
    }
    RUNTIME_EXECUTION {
        string execution_id PK
        string status "pending, running, completed, failed"
        datetime started_at
        datetime completed_at
    }
    LOG_ENTRIES {
        int id PK
        string execution_id FK
        string level "INFO, WARN, ERROR"
        string message
        datetime timestamp
    }
```
'@
    $erdContent = $erdTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($ERDFile, $erdContent, $utf8NoBom)
    Write-Host "[+] Created docs/ERD.md" -ForegroundColor Green
}

# 8. Generate docs/ARCHITECTURE.md
$ArchFile = Join-Path $DocsDir "ARCHITECTURE.md"
if (-not (Test-Path $ArchFile)) {
    $archTemplate = @'
# System Architecture & Component Flow: {{PROJECT_NAME}}

```mermaid
flowchart LR
    Inputs["Source Data / Inputs / Config"] --> Engine["Core Processing Engine / Strategy"]
    Engine --> Pipeline["Worker Pipeline / Processing"]
    Pipeline --> Storage["State / Datastore / Cache"]
    Pipeline --> Outputs["Generated Artifacts / Actions"]
```
'@
    $archContent = $archTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($ArchFile, $archContent, $utf8NoBom)
    Write-Host "[+] Created docs/ARCHITECTURE.md" -ForegroundColor Green
}

# 9. Generate docs/DESIGN.md (Best-Suited UI/UX Tokens, Tactical Patterns & ADR Decisions)
$DesignFile = Join-Path $DocsDir "DESIGN.md"
if (-not (Test-Path $DesignFile)) {
    $designTemplate = @'
# System & Interface Design Specifications (DESIGN): {{PROJECT_NAME}}

## 1. Tactical Design & Architectural Patterns
- **Core Design Pattern**: Modular Pipeline / Event-Driven / Layered Architecture.
- **Domain Boundaries**: Clean separation between data ingestion, core execution engine, and output sinks.

## 2. Interface & API Design Contracts
- **Contract Standard**: REST (OpenAPI 3.1) / JSON Schema / CLI Arguments.
- **Data Transfer Objects (DTOs)**: Strict input validation and sanitization.
- **Idempotency & Concurrency**: Mutation operations utilize unique idempotency keys and atomic transactions.

## 3. UI/UX Design System Specifications (Magic UI & Modern Standards)
- **Visual Standard**: Linear / Stripe / Apple-caliber modern aesthetics (crisp 1px borders, dark surface elevations, intentional motion).
- **Design Tokens**:
  - **Color Palette**: Dark base (`#09090b` / `#0f172a`), card surface (`#121217` / `#1e293b`), border (`#27272a` / `#334155`), primary accent (`#38bdf8`), success (`#10b981`), warning (`#f59e0b`), danger (`#ef4444`).
  - **Typography Scale**: System sans-serif with tabular numerals (`tabular-nums`) for numeric data.
  - **Spacing & Radius Scale**: 4px base grid; 6px / 8px / 12px border radius tiers.
  - **Interactive States**: Default, Hover, Active/Focus, Disabled, Loading/Skeleton (5-state interactive contract).

## 4. Magic UI Component Catalog & Integration Patterns
When generating web interfaces, prioritize Magic UI primitives over flat boilerplate:
- **React / Next.js / Laravel Inertia**:
  - **Hero**: `@magicui/retro-grid`, `@magicui/particles`, `@magicui/blur-fade`, `@magicui/shiny-button`.
  - **Features**: `@magicui/bento-grid`, `@magicui/magic-card`, `@magicui/border-beam`.
  - **Social Proof / Reviews**: `@magicui/marquee`.
  - **Metrics / Stats**: `@magicui/number-ticker` with tabular numerals.
  - **Installation on Demand**: `npx shadcn@latest add @magicui/<component-slug>`
- **Laravel Blade / Native HTML Templates**:
  - **Bento Grid**: Pure CSS Grid (`grid-cols-1 md:grid-cols-3 gap-4` with varying `md:col-span-2` / `md:row-span-2`).
  - **Infinite Marquee**: Pure CSS `@keyframes marquee` with horizontal flex track.
  - **Magic Card Glow**: Radial gradient overlay (`bg-[radial-gradient(circle_at_var(--mouse-x)_var(--mouse-y),rgba(56,189,248,0.15),transparent_80%)]`).
  - **Retro Grid**: Scalable SVG grid with perspective tilt and gradient fade mask.
- **Motion Budget**: Maximum 1–2 animated components per viewport; strictly respect `prefers-reduced-motion`.

## 5. Technical Decision Records (ADR / MADR)
| Decision ID | Context / Problem | Chosen Alternative | Key Rationale | Status |
| :--- | :--- | :--- | :--- | :--- |
| **ADR-01** | Stack & Architecture Foundation | {{STACK}} | Maximum runtime reliability, domain tooling, and maintainability | ✅ Accepted |
| **ADR-02** | Frontend Design Standard | Magic UI + Tailwind CSS | High perceived production value, animated modern aesthetic, zero AI slop | ✅ Accepted |
'@
    $designContent = $designTemplate.Replace("{{PROJECT_NAME}}", $ProjectName).Replace("{{STACK}}", $DetectedStack)
    [System.IO.File]::WriteAllText($DesignFile, $designContent, $utf8NoBom)
    Write-Host "[+] Created docs/DESIGN.md" -ForegroundColor Green
}

# 10. Generate docs/MEMORY.md (Universal Agent Working Memory Anchor)
$MemoryFile = Join-Path $DocsDir "MEMORY.md"
if (-not (Test-Path $MemoryFile)) {
    $memTemplate = @'
# {{PROJECT_NAME}} — Project Memory & Active Context

This document serves as the unified working memory anchor for AI agents (including `swarm-architect`, `fullstack-craftsman`, `quality-guardian`, and Antigravity core).

- **Domain**: {{DOMAIN}}
- **Tech Stack**: {{STACK}}
- **Initialized Date**: {{DATE}}
- **Detailed Machine Context**: [.agents/memory/context.md](file:///./.agents/memory/context.md)
- **Central Knowledge Base**: [docs/KNOWLEDGE_BASE.md](file:///./docs/KNOWLEDGE_BASE.md)

## Active Invariants & Decisions
1. **Additive-Only Evolution**: Never delete existing core modules, strategies, or configs without explicit confirmation.
2. **Multi-Conversation Synchronization**: Always verify and update `docs/KNOWLEDGE_BASE.md` before and after modifying schemas/APIs.
3. **Zero Plain-Text Secrets**: Keep API credentials in `.env` and reference via environment pointers.
4. **Mermaid 10+ Invariants**: Clean delimiters (no pipes in ER comments) and tab-activated lazy rendering.
'@
    $memContent = $memTemplate.Replace("{{PROJECT_NAME}}", $ProjectName).Replace("{{DOMAIN}}", $DetectedDomain).Replace("{{STACK}}", $DetectedStack).Replace("{{DATE}}", $NowDate)
    [System.IO.File]::WriteAllText($MemoryFile, $memContent, $utf8NoBom)
    Write-Host "[+] Created docs/MEMORY.md" -ForegroundColor Green
}

# 11. Generate docs/RULES.md (Coding Standards & Guardrails)
$RulesFile = Join-Path $DocsDir "RULES.md"
if (-not (Test-Path $RulesFile)) {
    $rulesTemplate = @'
# {{PROJECT_NAME}} — Coding Standards & Guardrails

Harmonized with the root `AGENTS.md` and Universal Vibe Coding Standards.

## 1. General Engineering Directives
- **Zero AI Slop**: Produce complete, working code. Never use `// TODO` or `// ... rest of code` placeholders.
- **Contract-First**: Define schemas and models before writing implementation routines.
- **Documentation Hygiene**: Update `docs/KNOWLEDGE_BASE.md`, `docs/ERD.md`, and `docs/TRACKER.md` on every architectural milestone.

## 2. Security & Credentials
- NEVER commit plain-text passwords, tokens, or private keys.
- Reference all secrets as environment pointers: `API_KEY: [Configured in .env -> API_KEY]`.

## 3. Mermaid v10+ Invariants
- **ERD (`erDiagram`)**: Zero pipe `|` delimiters in comments/types. Use comma `,` instead. Explicit entity blocks for all referenced entities.
- **Flowchart (`flowchart LR/TD`)**: Quote all node labels containing special characters: `id["Label (Details)"]`.
- **Dashboards (`index.html`)**: Initialize with `startOnLoad: false` and render lazily on tab activation.
'@
    $rulesContent = $rulesTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($RulesFile, $rulesContent, $utf8NoBom)
    Write-Host "[+] Created docs/RULES.md" -ForegroundColor Green
}

# 12. Generate or Upgrade docs/TRACKER.md (Unified Roadmap, Task Backlog & Milestone History)
$TrackerFile = Join-Path $DocsDir "TRACKER.md"
$LegacyWorklogFile = Join-Path $DocsDir "WORKLOG.md"

if (-not (Test-Path $TrackerFile)) {
    if (Test-Path $LegacyWorklogFile) {
        # Gracefully upgrade existing WORKLOG.md into TRACKER.md
        $workRaw = [System.IO.File]::ReadAllText($LegacyWorklogFile, $utf8NoBom)
        $trackerHeader = @"
# Project Roadmap, Task Backlog & Milestone History: $ProjectName

## 1. Active Sprint & Roadmap
| Task ID | Component | Task Description | Priority (MoSCoW) | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TASK-01** | Core | Living blueprint harmonization & memory alignment | Must Have | ✅ Completed |

---

## 2. Milestone History
"@
        $upgradedTracker = $workRaw -replace '^#\s+.*Worklog.*', $trackerHeader
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($TrackerFile, $upgradedTracker, $utf8NoBom)
        Write-Host "[+] Upgraded docs/WORKLOG.md -> docs/TRACKER.md (Unified Roadmap & Milestone History)" -ForegroundColor Green
    } else {
        $trackerTemplate = @'
# Project Roadmap, Task Backlog & Milestone History: {{PROJECT_NAME}}

## 1. Active Sprint & Roadmap
| Task ID | Component | Task Description | Priority (MoSCoW) | Status |
| :--- | :--- | :--- | :--- | :--- |
| **TASK-01** | Core | Initial living blueprint scaffolding & memory alignment | Must Have | ✅ Completed |
| **TASK-02** | Core | Primary pipeline implementation | Must Have | 🟡 In-Progress |
| **TASK-03** | Testing | Quality gate verification and test suite | Should Have | ⏳ Backlog |

---

## 2. Milestone History

### [{{DATE}}] Initial Blueprint Initialization
- **Summary**: Initialized universal living documentation suite, PRD, and portable memory.
- **Files Created**: `docs/` suite, `.agents/` context, root `AGENTS.md` and `CLAUDE.md`.
- **Status**: Ready for active development.
- **Next Steps**: Continue user feature implementation.
'@
        $trackerContent = $trackerTemplate.Replace("{{PROJECT_NAME}}", $ProjectName).Replace("{{DATE}}", $NowDate)
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($TrackerFile, $trackerContent, $utf8NoBom)
        Write-Host "[+] Created docs/TRACKER.md (Unified Roadmap & Milestone History)" -ForegroundColor Green
    }
}

# 13. Generate docs/ECOSYSTEM.md
$EcoFile = Join-Path $DocsDir "ECOSYSTEM.md"
if (-not (Test-Path $EcoFile)) {
    $ecoTemplate = @'
# Ecosystem & External Dependencies: {{PROJECT_NAME}}

## 1. External Services & Connected Systems
```mermaid
graph TD
    ThisApp["{{PROJECT_NAME}} (THIS PROJECT)"]
    ExternalAPIs["External APIs / Exchange / Cloud Providers"]
    SharedStorage[("Local / Cloud Storage")]

    ThisApp --> ExternalAPIs
    ThisApp --> SharedStorage
```

## 2. External Integration Registry
| Service / API | Purpose | Authentication Method | Rate Limit / Quota Notes |
| :--- | :--- | :--- | :--- |
| **External API** | Data ingestion or action execution | API Key / Token in .env | Respect provider rate limits |
'@
    $ecoContent = $ecoTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($EcoFile, $ecoContent, $utf8NoBom)
    Write-Host "[+] Created docs/ECOSYSTEM.md" -ForegroundColor Green
}

# 14. Generate docs/TROUBLESHOOTING.md
$TroubleFile = Join-Path $DocsDir "TROUBLESHOOTING.md"
if (-not (Test-Path $TroubleFile)) {
    $trTemplate = @'
# Troubleshooting & Environment Runbook: {{PROJECT_NAME}}

| Issue / Error | Root Cause | Exact Solution Recipe |
| :--- | :--- | :--- |
| **Missing Dependencies** | Environment not activated or packages uninstalled | Run package manager install (pip install -r requirements.txt / npm install / composer install). |
| **Permission or Path Error** | File access or working directory mismatch | Ensure commands are run from the project root. |
'@
    $trContent = $trTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($TroubleFile, $trContent, $utf8NoBom)
    Write-Host "[+] Created docs/TROUBLESHOOTING.md" -ForegroundColor Green
}

# 15. Generate or Update docs/index.html visual dashboard
$IndexDest = Join-Path $DocsDir "index.html"
$TemplateIndex = Join-Path $PSScriptRoot "..\templates\index.html"
if (Test-Path $TemplateIndex) {
    $rawTemplate = [System.IO.File]::ReadAllText($TemplateIndex, $utf8NoBom)
    $customIndex = $rawTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)

    # Smart Diagram Sync: Extract custom Mermaid diagrams if present in project docs
    function Extract-MermaidDiagram([string]$docPath) {
        if (-not (Test-Path $docPath)) { return $null }
        $content = [System.IO.File]::ReadAllText($docPath, $utf8NoBom)
        if ($content -match '(?ms)```mermaid\s*\r?\n(.*?)\r?\n```') {
            return $matches[1].Trim()
        }
        return $null
    }

    $customErd = Extract-MermaidDiagram (Join-Path $DocsDir "ERD.md")
    $customArch = Extract-MermaidDiagram (Join-Path $DocsDir "ARCHITECTURE.md")
    $customEco = Extract-MermaidDiagram (Join-Path $DocsDir "ECOSYSTEM.md")

    if ($customErd) {
        $tag = '<script type="text/plain" id="diagram-erd-src">'
        $pos = $customIndex.IndexOf($tag)
        if ($pos -ge 0) {
            $endPos = $customIndex.IndexOf('</script>', $pos)
            if ($endPos -ge 0) {
                $customIndex = $customIndex.Substring(0, $pos + $tag.Length) + "`r`n" + $customErd + "`r`n  " + $customIndex.Substring($endPos)
            }
        }
    }

    if ($customArch) {
        $tag = '<script type="text/plain" id="diagram-arch-src">'
        $pos = $customIndex.IndexOf($tag)
        if ($pos -ge 0) {
            $endPos = $customIndex.IndexOf('</script>', $pos)
            if ($endPos -ge 0) {
                $customIndex = $customIndex.Substring(0, $pos + $tag.Length) + "`r`n" + $customArch + "`r`n  " + $customIndex.Substring($endPos)
            }
        }
    }

    if ($customEco) {
        $tag = '<script type="text/plain" id="diagram-eco-src">'
        $pos = $customIndex.IndexOf($tag)
        if ($pos -ge 0) {
            $endPos = $customIndex.IndexOf('</script>', $pos)
            if ($endPos -ge 0) {
                $customIndex = $customIndex.Substring(0, $pos + $tag.Length) + "`r`n" + $customEco + "`r`n  " + $customIndex.Substring($endPos)
            }
        }
    }

    [System.IO.File]::WriteAllText($IndexDest, $customIndex, $utf8NoBom)
    Write-Host "[+] Generated docs/index.html visual dashboard (with smart diagram sync)" -ForegroundColor Green
}

# 16. Create or Harmonize root AGENTS.md (Antigravity Bridge)
$AgentsRootFile = Join-Path $ResolvedPath "AGENTS.md"
if (-not (Test-Path $AgentsRootFile)) {
    $agTemplate = @'
# {{PROJECT_NAME}} - Antigravity Agent Directives

Always consult the central living documentation before modifying code:
- **Central Knowledge Base**: [docs/KNOWLEDGE_BASE.md](file:///./docs/KNOWLEDGE_BASE.md)
- **Product Requirements (PRD)**: [docs/PRD.md](file:///./docs/PRD.md)
- **Architecture & Pipelines**: [docs/ARCHITECTURE.md](file:///./docs/ARCHITECTURE.md)
- **Design & UI Specifications**: [docs/DESIGN.md](file:///./docs/DESIGN.md)
- **Data & State Models**: [docs/ERD.md](file:///./docs/ERD.md)
- **Project Memory**: [docs/MEMORY.md](file:///./docs/MEMORY.md)
- **Coding Rules & Standards**: [docs/RULES.md](file:///./docs/RULES.md)
- **Roadmap & Task Tracker**: [docs/TRACKER.md](file:///./docs/TRACKER.md)
- **Ecosystem & APIs**: [docs/ECOSYSTEM.md](file:///./docs/ECOSYSTEM.md)
- **Runbook**: [docs/TROUBLESHOOTING.md](file:///./docs/TROUBLESHOOTING.md)

## Agent Operating Rules:
1. View `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md` before altering code, strategies, or schemas.
2. Update `docs/KNOWLEDGE_BASE.md` and `docs/ERD.md` after making architectural/data changes.
3. Record active sprint progress and completed milestone history in `docs/TRACKER.md` upon completing a task.
4. Never hardcode API keys or passwords; refer to `.env`.
5. Frontend Standard: When generating web pages, adopt Magic UI + shadcn/ui patterns (or pure Tailwind CSS equivalents in Laravel Blade).
6. Mermaid Diagrams: Never use '|' (pipes) in ER diagram comments or attribute definitions. In dashboards, ensure diagrams render lazily on tab activation.
7. Dual-Agent Bridge: Harmonized with `CLAUDE.md` for cross-tool interoperability with Claude Code.
'@
    $agContent = $agTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($AgentsRootFile, $agContent, $utf8NoBom)
    Write-Host "[+] Created root AGENTS.md" -ForegroundColor Green
}

# 17. Create or Harmonize root CLAUDE.md (Claude Code & Claude Desktop Bridge)
$ClaudeRootFile = Join-Path $ResolvedPath "CLAUDE.md"
if (-not (Test-Path $ClaudeRootFile)) {
    $claudeTemplate = @'
# {{PROJECT_NAME}} - Claude Code Agent Directives

You are operating on {{PROJECT_NAME}}. Follow the project living blueprints and vibe coding standards:

## Project Living Blueprints (Single Source of Truth)
- **Central Knowledge Base**: docs/KNOWLEDGE_BASE.md
- **Product Requirements (PRD)**: docs/PRD.md
- **Architecture & Pipelines**: docs/ARCHITECTURE.md
- **Design & UI Specifications**: docs/DESIGN.md (Magic UI + Modern Design Tokens)
- **Data & State Models**: docs/ERD.md
- **Project Memory**: docs/MEMORY.md
- **Coding Standards**: docs/RULES.md
- **Task & Sprint Tracker**: docs/TRACKER.md
- **External Ecosystem & APIs**: docs/ECOSYSTEM.md
- **Troubleshooting Runbook**: docs/TROUBLESHOOTING.md

## Core Agent Protocols
1. **Pre-Execution Check**: Read `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md` before altering code, database models, or API routes.
2. **Post-Execution Sync**: Update `docs/KNOWLEDGE_BASE.md` and `docs/ERD.md` on any schema, contract, or strategy changes.
3. **Log Progress**: Record active tasks and completed milestone history in `docs/TRACKER.md`.
4. **Security**: Zero plain-text credentials; use `.env` pointers.
5. **Frontend UI Standard**: When generating web interfaces, adopt Magic UI + shadcn/ui components (or pure Tailwind CSS equivalents for Laravel Blade).
6. **Mermaid Invariant**: No pipe symbols `|` inside ER diagrams.
7. **Dual-Agent Compatibility**: Harmonized with `AGENTS.md` for seamless handoff to Antigravity.
'@
    $claudeContent = $claudeTemplate.Replace("{{PROJECT_NAME}}", $ProjectName)
    [System.IO.File]::WriteAllText($ClaudeRootFile, $claudeContent, $utf8NoBom)
    Write-Host "[+] Created root CLAUDE.md (Dual Antigravity & Claude Bridge)" -ForegroundColor Green
}

Write-Host ">>> Living Blueprint Suite & Memory Ready! 100% Non-destructive." -ForegroundColor Cyan
