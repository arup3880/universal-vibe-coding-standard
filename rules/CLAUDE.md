# Universal Claude Vibe Coding Standards & Protocols

You are paired with the developer using Claude (Claude Code CLI or Claude Desktop) to build robust, scalable projects across any technical domain (e.g. web applications, algorithmic trading engines like Freqtrade, media/video processing pipelines, CLI tools, ML/AI systems, or microservices). You must enforce the following operating standards across all workspaces.

---

## 1. Blueprint Check & "On-First-Chat" Safe Upgrade
Whenever you enter a workspace or respond to a prompt in any project:
1. **Check for Blueprints**: Check if `docs/KNOWLEDGE_BASE.md` and `.agents/` exist in the project root.
2. **If MISSING (First chat in an existing project OR a brand-new project)**:
   - Perform a **safe, non-destructive initialization**:
     - Inspect the project to detect its domain, tech stack (Python, Node, PHP, Go, Rust, etc.), configuration files, and existing documentation/code.
     - Create `.agents/memory/context.md` (recording current project objectives, domain, and architecture).
     - Create the unified standard `docs/` suite:
       - `PRD.md` (Product Requirements Document — features, scope matrix, user stories, NFRs)
       - `ARCHITECTURE.md` (System topology, component boundaries, data flow pipelines)
       - `DESIGN.md` (Tactical patterns, UI/UX design tokens, Magic UI catalog, 5-state contracts, ADR decisions)
       - `MEMORY.md` (Unified agent memory anchor, harmonized with `.agents/memory/context.md`)
       - `RULES.md` (Project coding standards, invariants, guardrails; harmonized with root `CLAUDE.md` and `AGENTS.md`)
       - `TRACKER.md` (Active sprint roadmap, task backlog, and milestone history)
       - `KNOWLEDGE_BASE.md` (Multi-conversation architectural source of truth)
       - `ERD.md` (Data and state models, strictly Mermaid 10+ compliant)
       - `ECOSYSTEM.md` (External APIs, hardware, cloud services, and sister repositories)
       - `TROUBLESHOOTING.md` (Self-healing environment runbook)
       - `index.html` (Offline single-view visual dashboard)
     - Create or harmonize the root `CLAUDE.md` and `AGENTS.md`.
     - **CRITICAL SAFETY GUARANTEE**: Strictly additive-only. Never delete, rename, or overwrite existing application code, strategies, pipeline scripts, config files (`.env`, `config.json`, `settings.json`), or data stores.
     - Note the initialization in `docs/TRACKER.md` and inform the user.
3. **If PRESENT**: Follow the standard multi-conversation protocol below.

---

## 2. Multi-Conversation Shared Knowledge Base Protocol
Multiple conversations and agents frequently operate on this codebase. To prevent hallucinations and collisions:
1. **Pre-Execution Context Anchor**: Before proposing or modifying code, data models, strategies, or configurations, view `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md` to verify existing architectural contracts, state definitions, pipeline flows, and component dependencies. Never assume or invent conflicting structures.
2. **Post-Execution Knowledge Updation**: Whenever you add or alter a data schema, model, strategy, API endpoint, worker pipeline, or configuration contract in *any* session, you **MUST** update `docs/KNOWLEDGE_BASE.md` (and `docs/ERD.md` / `ARCHITECTURE.md` if data flow or schema changed) before concluding the turn.

---

## 3. Security & Credential Protection Guardrail
- **Zero Plain-Text Secrets**: NEVER write actual secrets (e.g. exchange API keys/secrets, database passwords, OAuth tokens, private keys) into any markdown or documentation file.
- Always document credentials as environment pointers, e.g.: `EXCHANGE_API_KEY: [Configured in .env -> EXCHANGE_API_KEY]`.
- Ensure `.env` is never removed from `.gitignore`.

---

## 4. State Synchronization & Progress Tracking
- Conclude every completed milestone by appending a concise entry to `docs/TRACKER.md` with Timestamp, Summary, Files Touched, and Next Steps.
- Sync `docs/MEMORY.md` (and `.agents/memory/context.md`) if high-level objectives or architectural decisions changed.
- Provide a recommended semantic git commit message (e.g., `feat(ui): add magic-ui bento grid section`).

---

## 5. Mermaid Diagram & Dashboard Invariant (Mermaid v10+ Compatibility)
1. **ER Diagrams (`erDiagram`)**: Zero pipe `|` delimiters inside entity attribute descriptions, comments, or types. Explicit entity definitions for all entities.
2. **Flowcharts (`flowchart LR` / `flowchart TD`)**: Always wrap node labels containing special characters in double quotes: `nodeId["Label (Details)"]`.
3. **Offline Dashboards (`docs/index.html`)**: Tab-activated lazy rendering (`startOnLoad: false`) to avoid hidden container zero-bounding-box layout crashes.

---

## 6. Dual Antigravity & Claude Interoperability Protocol
1. **Dual Bridge Files**: Every project maintains **both** root `CLAUDE.md` and root `AGENTS.md`. Both point to `docs/` as the single canonical source of truth.
2. **State Sharing**: Tasks completed by Claude are logged in `docs/TRACKER.md` so Antigravity can resume seamlessly, and vice versa.

---

## 7. Magic UI Modern Frontend Engineering Standard
To eradicate generic "AI slop" interfaces and deliver high-production-value, modern web applications:

1. **Smart On-Demand Workflow**:
   - Prioritize **Magic UI + shadcn/ui** patterns over flat, uninspired boilerplate.
   - **React / Next.js / Laravel Inertia (React/Vue)**:
     - Check if `components.json` (shadcn) exists. If missing, initialize via `npx shadcn@latest init -d`.
     - Selectively install required Magic UI component slugs on-demand (e.g. `npx shadcn@latest add @magicui/<component-slug>`).
     - Standard registry components:
       - **Hero**: `@magicui/retro-grid`, `@magicui/particles`, `@magicui/blur-fade`, `@magicui/shiny-button`.
       - **Features**: `@magicui/bento-grid`, `@magicui/magic-card`, `@magicui/border-beam`.
       - **Social Proof / Integrations**: `@magicui/marquee`.
       - **Dashboards & Metrics**: `@magicui/number-ticker`, tabular numerals.
   - **Laravel Blade / Native HTML Templates**:
     - Deliver identical visual polish using **Pure Tailwind CSS utilities & keyframes**:
       - *Bento Grid*: Asymmetric CSS Grid (`grid-cols-1 md:grid-cols-3 gap-4` with col/row spans).
       - *Infinite Marquee*: CSS `@keyframes marquee` with flex containers.
       - *Magic Card Glow*: Radial gradient masks (`bg-[radial-gradient(...)]`) with hover border transitions.
       - *Retro Grid*: SVG background grid with CSS perspective transform and fade mask.
2. **Design System & Motion Budget**:
   - Adhere to design tokens in `docs/DESIGN.md`: dark base (`#09090b` / `#0f172a`), crisp 1px borders (`border-border` / `#27272a`), 5-state interactive contracts (default, hover, active, disabled, loading).
   - Limit high-motion effects to maximum 1–2 per visible viewport to preserve 60fps performance and WCAG accessibility (`motion-reduce`).
