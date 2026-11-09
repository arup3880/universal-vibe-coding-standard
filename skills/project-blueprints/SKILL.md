---
name: project-blueprints
description: >-
  Scaffolds, audits, and upgrades projects with the universal living documentation suite
  (docs/PRD.md, ARCHITECTURE.md, DESIGN.md, MEMORY.md, RULES.md, TRACKER.md, KNOWLEDGE_BASE.md, ERD.md,
  ECOSYSTEM.md, TROUBLESHOOTING.md, and offline visual dashboard index.html) and portable in-project memory.
---

# Project Living Blueprints & Knowledge Base Skill

Use this skill to inspect, scaffold, or upgrade any workspace to adhere to the Universal Vibe Coding Standard.

## What This Skill Does

1. **Non-Destructive Initialization & Upgrade**:
   - Inspects existing files (e.g. `artisan`, `composer.json`, `package.json`, `.env`) to auto-detect framework, database, and stack.
   - Non-destructively generates or upgrades `docs/` containing:
     - `PRD.md` (Product Requirements Document — user personas, MoSCoW scope matrix, acceptance criteria, NFR budgets; upgraded from legacy `SRS.md`)
     - `ARCHITECTURE.md` (System topology, component boundaries, worker pipelines)
     - `DESIGN.md` (UI/UX design system, color & typography tokens, 5-state interactive contracts, ADR decision log)
     - `MEMORY.md` (Universal working memory anchor, harmonized with `.agents/memory/context.md`)
     - `RULES.md` (Project coding standards, invariants, and guardrails; harmonized with root `AGENTS.md`)
     - `TRACKER.md` (Active sprint roadmap, task backlog, and milestone changelog; upgraded from legacy `WORKLOG.md`)
     - `KNOWLEDGE_BASE.md` (Multi-conversation single source of truth)
     - `ERD.md` (Visual Mermaid database schema, strictly Mermaid 10+ compliant)
     - `ECOSYSTEM.md` (Cross-project relations, shared databases, external APIs)
     - `TROUBLESHOOTING.md` (Self-healing runbook & environment fixes)
     - `index.html` (Standalone offline browser dashboard with resilient tab-activated lazy rendering)
   - Generates `.agents/memory/context.md` for portable project memory across machines.
   - Generates or harmonizes root **`AGENTS.md`** (for Antigravity) and root **`CLAUDE.md`** (for Claude Code).

## Automatic Execution

Run the built-in PowerShell helper from any workspace:

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\config\plugins\vibe-coding-standard\skills\project-blueprints\scripts\scaffold.ps1" -ProjectPath "$PWD"
```

To quickly initialize Magic UI components (Bento Grid, Magic Card, Marquee, Blur Fade, Shiny Button) in a React / Next.js / Laravel Inertia project:

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\config\plugins\vibe-coding-standard\skills\project-blueprints\scripts\setup-magic-ui.ps1" -ProjectPath "$PWD"
```

## Agent Operating Rules Enforced

- **Always Read First**: Consult `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md` before altering database tables or routes.
- **Always Sync on Change**: Update `docs/KNOWLEDGE_BASE.md` and `docs/ERD.md` whenever migrations or models change.
- **Redact Credentials**: Never write plain-text passwords into documentation.
- **Log Milestones**: Conclude every task with an entry in `docs/TRACKER.md` (or legacy `docs/WORKLOG.md`).
- **Magic UI Frontend Standard**: Adopt Magic UI + shadcn/ui patterns for React/Next.js/Inertia; use pure Tailwind CSS utility equivalents for Laravel Blade.
- **Dual Bridge Compatibility**: Respect both `AGENTS.md` and `CLAUDE.md` for seamless handoff between Antigravity and Claude Code.
- **Mermaid 10+ Invariant**: Never use `|` (pipe) in ER comments; quote flowchart labels; use resilient lazy loading in `docs/index.html` to avoid `display: none` bounding box crashes.
- **Google EGM Review Gate**: Partition documentation into `FeatureRange` (`docs/PRD.md`, `docs/ARCHITECTURE.md`) and `DetailedRange` (`docs/DESIGN.md`, `docs/ERD.md`). Run `/egm:egm-review <doc>` to audit against YAGNI, naive comprehension, and failure modes, resolving findings (`/egm:egm-resolve`) before writing implementation code. Run `/egm:egm-drift-report` to detect spec drift.
