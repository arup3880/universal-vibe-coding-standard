# Universal Vibe Coding Standard (`vibe-coding-standard`)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Antigravity Plugin](https://img.shields.io/badge/Antigravity-Plugin-brightgreen.svg)](plugin.json)
[![Claude Ready](https://img.shields.io/badge/Claude-Code%20Ready-orange.svg)](rules/CLAUDE.md)
[![Magic UI](https://img.shields.io/badge/Frontend-Magic%20UI-purple.svg)](docs/DESIGN.md)
[![Version](https://img.shields.io/badge/version-1.3.0-blueviolet.svg)](plugin.json)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg)](CONTRIBUTING.md)

Enterprise-grade **living documentation**, **multi-conversation knowledge base synchronization**, **dual Antigravity & Claude compatibility**, and **Magic UI modern frontend standards** for AI pair programming.

Works seamlessly across any domain — **Algorithmic Trading (Freqtrade), Video Generation Pipelines, Web Applications (Next.js, React, Laravel Blade/Inertia), Cloud Microservices, and Machine Learning systems**.

---

## 🌟 Why This Plugin?

When developing real-world software with AI assistants:
1. **Parallel Conversations Collide**: Chat A modifies a schema or API while Chat B writes outdated queries.
2. **Context Loss Between Sessions**: Knowledge vanishes between chat restarts or when transferring code to another computer.
3. **Waterfall Obsolescence**: Static documentation becomes obsolete immediately as code evolves.
4. **Tooling & Diagram Crashes**: Mermaid diagrams in IDEs and web dashboards often fail due to syntax incompatibilities or bounding box rendering bugs.

**`vibe-coding-standard` solves all of these out of the box.**

---

## 🚀 Key Features

### 1. Unified 6-Document Living Blueprint Suite
Every project maintains the canonical modern document architecture in `docs/`:
- **`PRD.md`**: Product Requirements Document (features, user personas, MoSCoW scope matrix, verifiable acceptance criteria, and NFR performance budgets).
- **`ARCHITECTURE.md`**: System Architecture & Component Flow (subsystems, bounded contexts, worker pipelines).
- **`DESIGN.md`**: Tactical design patterns, Linear/Stripe design tokens (crisp 1px borders, tabular numerals, 5-state interactive contracts), and Architecture Decision Records (ADRs).
- **`MEMORY.md`**: Universal agent working memory anchor, harmonized with `.agents/memory/context.md`.
- **`RULES.md`**: Project coding standards, anti-slop directives, credential protection, and Mermaid invariants.
- **`TRACKER.md`**: Active sprint roadmap, task backlog, and historical milestone changelog.

Plus the shared knowledge infrastructure:
- **`KNOWLEDGE_BASE.md`**: Multi-conversation architectural source of truth.
- **`ERD.md`**: Data and state models (strictly pipe-free Mermaid v10+ format).
- **`ECOSYSTEM.md`**: External APIs, hardware interfaces, cloud services, and sister repositories.
- **`TROUBLESHOOTING.md`**: Self-healing environment runbook and error resolution logs.
- **`index.html`**: Standalone offline browser dashboard with 7 tabs and **Smart Diagram Sync**.

### 2. "On-First-Chat" Safe Non-Destructive Scaffolding
- When opening any project for the first time, the plugin inspects the tech stack (`Python`, `Node.js`, `Laravel/PHP`, `Go`, `Rust`, etc.) and sets up the documentation suite in seconds.
- **Strictly Additive**: Never touches, renames, or deletes existing application code, strategies, tests, or config files.
- **Graceful Legacy Upgrades**: Automatically detects legacy `SRS.md` or `WORKLOG.md` files and upgrades them into `PRD.md` and `TRACKER.md` without losing any historical records.

### 3. Smart Diagram Sync (Offline Dashboard)
- Open `docs/index.html` directly in any web browser without needing a local web server.
- Automatically extracts custom Mermaid diagrams from `docs/ERD.md` and `docs/ARCHITECTURE.md` and renders them in dark mode.
- Uses **tab-activated lazy rendering** to prevent Mermaid v10+ `display: none` zero-bounding-box layout crashes.

### 4. Swarm Architect & Vibes-Plug Synergy
- 100% harmonized with the `vibes-plug` agent swarm (`swarm-architect`, `fullstack-craftsman`, `quality-guardian`).
- Guarantees zero taxonomy collisions and preserves domain-specific databases (e.g. SQLite for trading bots, DuckDB for analytics) rather than forcing SaaS PostgreSQL defaults.

### 5. Multi-System Portability
- All project memory and directives are stored **directly inside the project directory** (`docs/` and `.agents/`).
- Moving the project folder to a USB drive, another computer, or a server preserves 100% of the agent's context and working memory.

### 6. Dual Antigravity & Claude Interoperability
- Generates **both** root `AGENTS.md` (read natively by Antigravity) and root `CLAUDE.md` (read natively by Claude Code and Claude Desktop).
- Both bridge files point to the exact same canonical `docs/` suite.
- When you switch between Antigravity in your IDE and Claude Code in your terminal, both agents read and update the same `KNOWLEDGE_BASE.md` and `TRACKER.md` without collisions or hallucination.

### 7. Magic UI Modern Frontend Standard (Eradicating AI Slop)
- When generating web pages, sections, or components, the agent automatically adopts **Magic UI + shadcn/ui** patterns rather than flat, outdated boilerplate:
  - **Hero**: Retro Grid, Animated Particles, Blur-Fade typography, Shiny Button.
  - **Features**: Bento Grid layout with interactive Magic Card hover glow and Border Beam.
  - **Social Proof**: Infinite smooth horizontal Marquee.
  - **Dashboards**: Number Ticker with tabular numerals and clean 1px borders.
- **Smart On-Demand Flow**:
  - **React / Next.js / Laravel Inertia**: Auto-initializes shadcn (`npx shadcn@latest init -d`) and installs required `@magicui/*` component slugs on demand.
  - **Laravel Blade / Pure HTML**: Uses equivalent **Pure Tailwind CSS utilities & keyframes** (CSS Bento Grid, CSS Marquee, Radial Glow cards) so Blade projects look equally modern without requiring a heavy JS runtime.


---

## 📦 Installation

### Quick Install (Windows)
1. Download or clone this repository to your machine.
2. Run the 1-click batch installer:
   ```cmd
   install-on-another-system.bat
   ```
   *(Or run PowerShell: `powershell -ExecutionPolicy Bypass -File install-on-another-system.ps1`)*

The installer copies the plugin into `~/.gemini/config/plugins/vibe-coding-standard` and automatically registers it in `~/.gemini/config/config.json`.

---

## 🛠 Usage

### Automatic Mode
Simply open any project with Antigravity and start chatting! The global rule automatically detects whether living blueprints are initialized and safely guides your project.

### Manual / CLI Scaffolding
To scaffold or audit an existing project instantly from PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File "~/.gemini/config/plugins/vibe-coding-standard/skills/project-blueprints/scripts/scaffold.ps1" -ProjectPath "C:\path\to\your\project"
```

To pre-install the core Magic UI suite (Bento Grid, Magic Card, Marquee, Blur Fade, Shiny Button) into a React / Next.js / Laravel Inertia project:
```powershell
powershell -ExecutionPolicy Bypass -File "~/.gemini/config/plugins/vibe-coding-standard/skills/project-blueprints/scripts/setup-magic-ui.ps1" -ProjectPath "C:\path\to\your\project"
```

---

## 🔒 Security & Credential Protection
- **Zero Plain-Text Secrets**: The plugin strictly forbids hardcoded API keys, database passwords, or private tokens in documentation.
- Secrets are always referenced as environment pointers:
  ```markdown
  EXCHANGE_API_KEY: [Configured in .env -> EXCHANGE_API_KEY]
  ```

---

## 🤝 Contributing & Community Upgrades

We welcome contributions, feature requests, and bug reports!
Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to propose enhancements, add new domain detectors, or refine blueprint templates.

---

## 📄 License

Distributed under the [MIT License](LICENSE). You are free to use, modify, and distribute this plugin for personal and commercial projects.
