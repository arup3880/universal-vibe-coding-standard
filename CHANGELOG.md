# Changelog

All notable changes to the **Universal Vibe Coding Standard** plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.3.0] - 2026-11-09

### Added
- **Dual Antigravity & Claude Interoperability**:
  - Automatically scaffolds both `AGENTS.md` (for Antigravity) and `CLAUDE.md` (for Claude Code and Claude Desktop) in project root.
  - Added global Claude rule file `rules/CLAUDE.md`.
  - Added Claude detection to `install-on-another-system.ps1` for automatic cross-tool registration.
- **Magic UI Modern Frontend Engineering Standard**:
  - Smart on-demand frontend workflow targeting React, Next.js, and Laravel Inertia.
  - Automatic `shadcn/ui` detection and selective `@magicui/*` slug installation.
  - Pure Tailwind CSS & keyframe equivalents for Laravel Blade and static HTML (Bento Grid, CSS Marquee, Radial Card Glow, Retro Grid).
  - Added 1-click helper script `setup-magic-ui.ps1`.
- **Hardened Path & Encoding Reliability**:
  - Replaced literal paths with `-LiteralPath` guards across PowerShell scripts to support bracketed folder names (`[Test] Project`).
  - Standardized on UTF-8 without BOM across all file writers.
  - Added Node.js/npx dependency pre-flight check in `setup-magic-ui.ps1`.

### Changed
- Rebranded plugin title to **Universal Vibe Coding Standard**.
- Unified task tracking and milestone changelog into `docs/TRACKER.md`.

---

## [1.2.0] - 2026-10-20

### Added
- **Swarm Architect & Vibes-Plug Synergy**:
  - Full compatibility with `swarm-architect`, `fullstack-craftsman`, and `quality-guardian`.
  - Canonical 6-document living blueprint suite (`PRD.md`, `ARCHITECTURE.md`, `DESIGN.md`, `MEMORY.md`, `RULES.md`, `TRACKER.md`).
- **Smart Diagram Sync in Dashboard**:
  - `docs/index.html` dynamically parses and embeds custom Mermaid diagrams from `docs/ERD.md` and `docs/ARCHITECTURE.md`.
- **Mermaid 10+ Syntax Guardrails**:
  - Enforced zero pipe `|` delimiters in ER diagrams to prevent IDE and web renderer syntax crashes.
  - Enforced tab-activated lazy rendering (`startOnLoad: false`) in `docs/index.html`.

### Changed
- Upgraded legacy `SRS.md` non-destructively to `PRD.md`.
- Upgraded legacy `WORKLOG.md` non-destructively to `TRACKER.md`.

---

## [1.0.0] - 2026-09-26

### Added
- Initial public release of Universal Vibe Coding Standard.
- Multi-conversation shared knowledge base protocol (`docs/KNOWLEDGE_BASE.md`).
- Portable in-project agent memory (`.agents/memory/context.md`).
- Offline zero-dependency browser dashboard (`docs/index.html`).
- 1-click cross-machine installation scripts (`install-on-another-system.bat` / `.ps1`).
