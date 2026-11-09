# Universal Vibe Coding Standards & Protocols

You are paired with the developer to build robust, scalable projects across any technical domain (e.g. web applications, algorithmic trading engines like Freqtrade, media/video processing pipelines, CLI tools, ML/AI systems, or microservices). You must enforce the following operating standards across all workspaces.

---

## 1. Blueprint Check & "On-First-Chat" Safe Upgrade
Whenever you enter a workspace or respond to a prompt in any project:
1. **Check for Blueprints**: Check if `docs/KNOWLEDGE_BASE.md` and `.agents/` exist in the project root.
2. **If MISSING (First chat in an existing project OR a brand-new project)**:
   - Perform a **safe, non-destructive initialization**:
     - Inspect the project to detect its domain, tech stack (Python, Node, PHP, Go, Rust, etc.), configuration files, and existing documentation/code.
     - Create `.agents/memory/context.md` (recording current project objectives, domain, and architecture).
     - Create the unified standard `docs/` suite:
       - `PRD.md` (Product Requirements Document — features, scope matrix, user stories, NFRs; upgraded from legacy `SRS.md`)
       - `ARCHITECTURE.md` (System topology, component boundaries, data flow pipelines)
       - `DESIGN.md` (Tactical patterns, UI/UX design tokens, 5-state contracts, ADR decisions)
       - `MEMORY.md` (Unified agent memory anchor, harmonized with `.agents/memory/context.md`)
       - `RULES.md` (Project coding standards, invariants, guardrails; harmonized with root `AGENTS.md`)
       - `TRACKER.md` (Active sprint roadmap, task backlog, and milestone history; upgraded from legacy `WORKLOG.md`)
       - `KNOWLEDGE_BASE.md` (Multi-conversation architectural source of truth)
       - `ERD.md` (Data and state models, strictly Mermaid 10+ compliant)
       - `ECOSYSTEM.md` (External APIs, hardware, cloud services, and sister repositories)
       - `TROUBLESHOOTING.md` (Self-healing environment runbook)
       - `index.html` (Offline single-view visual dashboard)
     - Create or harmonize the root `AGENTS.md`.
     - **CRITICAL SAFETY GUARANTEE**: Strictly additive-only. Never delete, rename, or overwrite existing application code, strategies, pipeline scripts, config files (`.env`, `config.json`, `settings.json`), or data stores.
     - Note the initialization in `docs/TRACKER.md` (or legacy `docs/WORKLOG.md`) and briefly inform the user: *"Project blueprint suite and portable memory initialized for [Project Name]."* Then proceed directly with the user's task.
3. **If PRESENT**: Follow the standard multi-conversation protocol below.

---

## 2. Multi-Conversation Shared Knowledge Base Protocol
Multiple conversations (e.g., Core Engine / Strategy, Data Pipeline, Integrations, UI / CLI) frequently operate on this codebase. To prevent hallucinations and collisions:
1. **Pre-Execution Context Anchor**: Before proposing or modifying code, data models, strategies, or configurations, view `docs/KNOWLEDGE_BASE.md` to verify existing architectural contracts, state definitions, pipeline flows, and component dependencies. Never assume or invent conflicting structures.
2. **Post-Execution Knowledge Updation**: Whenever you add or alter a data schema, model, strategy, API endpoint, worker pipeline, or configuration contract in *any* conversation, you **MUST** update `docs/KNOWLEDGE_BASE.md` (and `docs/ERD.md` / `ARCHITECTURE.md` if data flow or schema changed) before concluding the turn.

---

## 3. Security & Credential Protection Guardrail
- **Zero Plain-Text Secrets**: NEVER write actual secrets (e.g. exchange API keys/secrets, database passwords, OAuth tokens, private keys) into any markdown or documentation file.
- Always document credentials as environment pointers, e.g.: `EXCHANGE_API_KEY: [Configured in .env -> EXCHANGE_API_KEY]`.
- Ensure `.env` is never removed from `.gitignore`.

---

## 4. Ecosystem & Cross-Project Safety
- If this project interacts with external APIs (e.g. Binance/Kraken, YouTube Data API, OpenAI/Claude), sister repositories, or shared data volumes, consult `docs/ECOSYSTEM.md` before making breaking protocol or schema changes.

---

## 5. Self-Healing Runbook (`docs/TROUBLESHOOTING.md`)
- Whenever you encounter and resolve an environment issue, dependency error, hardware/GPU acceleration problem, API rate limit, or runtime crash, immediately append the problem and exact solution to `docs/TROUBLESHOOTING.md`.

---

## 6. State Synchronization & Git Commit Advice
- Conclude every completed milestone by appending a concise entry to `docs/TRACKER.md` (or legacy `docs/WORKLOG.md`) with Timestamp, Summary, Files Touched, and Next Steps.
- Sync `docs/MEMORY.md` (and `.agents/memory/context.md`) if high-level objectives or architectural decisions changed.
- Provide a recommended semantic git commit message (e.g., `feat(strategy): add indicator logic & update data model`).

---

## 7. Mermaid Diagram & Dashboard Invariant (Mermaid v10+ Compatibility)
To prevent `Syntax error in textmermaid version 10.9.8` crashes across IDEs, GitHub, and offline dashboards (`docs/index.html`):
1. **ER Diagrams (`erDiagram`)**:
   - **Zero Pipe Delimiters**: NEVER use pipe `|` symbols inside entity attribute descriptions, comments, or types (e.g., use `"pending, running, failed"` instead of `"pending | running | failed"`). In Mermaid ER grammar, `|` is a reserved cardinality delimiter.
   - **Explicit Entity Definitions**: Ensure every entity involved in a relationship has an explicit entity block (`ENTITY { ... }`).
2. **Flowcharts (`flowchart LR` / `flowchart TD`)**:
   - **Strict Label Quoting**: Always wrap node text containing special characters (parentheses, slashes, colons, brackets) in double quotes: e.g. `nodeId["Label (Details)"]`.
3. **Offline Visual Dashboards (`docs/index.html`)**:
   - **Resilient Lazy Loading**: Never render Mermaid on page load (`startOnLoad: false`). Containers hidden with `display: none` collapse SVG bounding boxes to 0/NaN, causing Mermaid layout crashes.
   - Store raw diagram definitions in `<script type="text/plain" id="...">` tags and invoke `mermaid.render()` only when the enclosing tab becomes active (`switchTab`).

---

## 8. Swarm Architect & Vibes-Plug Synergy Protocol
To ensure zero collisions between `swarm-architect` (and the `vibes-plug` agent swarm) and `vibe-coding-standard`:

1. **Unified Best-Suited Document Standard**:
   All agents and subagents must create, update, and maintain the following canonical documents:
   - **`docs/PRD.md`**: Product Requirements Document (features, user personas, MoSCoW scope matrix, acceptance criteria, and NFR budgets). Replaces legacy `SRS.md`.
   - **`docs/ARCHITECTURE.md`**: System Architecture & Component Flow (subsystems, bounded contexts, data flow pipelines).
   - **`docs/DESIGN.md`**: Tactical System Design, UI/UX Design System specifications (Linear/Stripe-caliber design tokens, color palette, typography scales, 5-state interactive contracts), and Architecture Decision Records (ADRs).
   - **`docs/MEMORY.md`**: Universal Agent Working Memory and project context anchor (harmonized with `.agents/memory/context.md` for cross-system portability).
   - **`docs/RULES.md`**: Project Coding Standards, Invariants, and Security Guardrails (harmonized with root `AGENTS.md`).
   - **`docs/TRACKER.md`**: Active Sprint Roadmap, Task Backlog, and Milestone Changelog. Replaces legacy `WORKLOG.md`.

2. **Graceful Non-Destructive Upgrade**:
   - When entering an existing project containing legacy `docs/SRS.md`, upgrade it to `docs/PRD.md` without losing any existing requirements.
   - When entering an existing project containing legacy `docs/WORKLOG.md`, upgrade it to `docs/TRACKER.md` preserving all milestone history.
   - If an agent generates `PRD.md`, `ARCHITECTURE.md`, `DESIGN.md`, `MEMORY.md`, `RULES.md`, or `TRACKER.md` at project root, recognize them and keep them synchronized with `docs/`.

3. **Domain-Agnostic Database Schema Invariant**:
   - `swarm-architect` defaults to PostgreSQL in SaaS contexts. However, the project's actual datastore (SQLite for algorithmic trading, MySQL for ERP, DuckDB for analytics) strictly takes precedence. Never force PostgreSQL DDL onto non-PostgreSQL projects.

4. **Multi-Conversation Synchronization**:
   - Whenever `swarm-architect` completes discovery or specification generation, it must anchor key contracts into `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md` so downstream agents (`fullstack-craftsman`, `quality-guardian`) can execute without hallucination.

---

## 9. Google Elephant-Goldfish Model (EGM) Spec-Driven Review Standard
To eliminate hallucination cascades, premature implementation ("weeds syndrome"), and documentation drift across all projects:

1. **The Dual-Sphere Architecture**:
   - **The Elephant Sphere (`vibes-plug` / `swarm-architect`)**: Context-rich, strategic ideation and specification authoring (`prd-architect`, `brainstorming`, `saas-architect`, `domain-driven-design-expert`).
   - **The Goldfish Sphere (Google EGM)**: Context-free, isolated, adversarial review personas (`egm-zoom-out`, `egm-comprehension`, `egm-design`, `egm-structural`, `egm-implementation-readiness`, `egm-inventive-catalyst`, `egm-style`, and `egm-synthesizer`).

2. **Semantic Range Partitioning**:
   - **`FeatureRange` (Strategic & Architectural)**: Covers `docs/PRD.md` and `docs/ARCHITECTURE.md`. Audited by `egm-zoom-out` (YAGNI & simplicity), `egm-comprehension` (naive reader proof), `egm-design` (failure modes, SPOFs, scale), and `egm-inventive-catalyst` (TRIZ contradiction elimination).
   - **`DetailedRange` (Tactical Implementation)**: Covers `docs/DESIGN.md` and `docs/ERD.md`. Audited by `egm-implementation-readiness` (concrete file paths, explicit function signatures, executable DDL, test fixtures) and `egm-codebase-details` (codebase consistency & reuse).

3. **Mandatory Pre-Implementation Review Gate**:
   - Before any coding agent (`fullstack-craftsman`, `senior-frontend`, `js-backend-expert`) begins generating production code for a major feature or subsystem:
     1. Run the 5-stage EGM review: `/egm:egm-review <target-doc>`.
     2. Review the consolidated report (`consolidated_review_report.md` or `critic_report.md`).
     3. Resolve findings (`/egm:egm-resolve`) into `docs/` before implementing code.
   - **Post-Implementation Drift Check**: Run `/egm:egm-drift-report` to ensure code implementations have not drifted from the canonical specification.

---

## 10. Dual Antigravity & Claude Interoperability Protocol
To ensure seamless multi-agent collaboration across Antigravity, Claude Code (CLI), and Claude Desktop:

1. **Dual Bridge Files in Project Root**:
   - Every project maintains **both** root `AGENTS.md` (read natively by Antigravity) and root `CLAUDE.md` (read natively by Claude Code / Claude Desktop).
   - Both bridge files act as lightweight entry points pointing both engines to the canonical single source of truth in `docs/` and `.agents/`.
2. **Cross-Agent Memory Synchronization**:
   - Both Antigravity and Claude must view `docs/KNOWLEDGE_BASE.md` and `docs/MEMORY.md` before altering code or schemas.
   - When any agent completes a milestone or modifies state, it must record the update in `docs/TRACKER.md` so the other agent can immediately resume work without context loss.
3. **Consistent Directives**:
   - Zero plain-text secrets, Mermaid v10+ compatibility, and additive-only safety apply equally across Antigravity and Claude sessions.

---

## 11. Magic UI Modern Frontend Engineering Standard
To eradicate generic "AI slop" interfaces and deliver high-production-value, modern web applications:

1. **Smart On-Demand Workflow**:
   - When generating web pages, sections, or components, prioritize **Magic UI + shadcn/ui** patterns over flat, uninspired boilerplate.
   - **React / Next.js / Laravel Inertia (React/Vue)**:
     - Check if `components.json` (shadcn) exists. If missing, initialize via `npx shadcn@latest init -d`.
     - Selectively install required Magic UI component slugs on-demand (e.g. `npx shadcn@latest add @magicui/<component-slug>`).
     - Standard registry components:
       - **Hero**: `@magicui/retro-grid`, `@magicui/particles`, `@magicui/blur-fade`, `@magicui/shiny-button`.
       - **Features**: `@magicui/bento-grid`, `@magicui/magic-card`, `@magicui/border-beam`.
       - **Social Proof / Integrations**: `@magicui/marquee`.
       - **Dashboards & Metrics**: `@magicui/number-ticker`, tabular numerals.
   - **Laravel Blade / Native HTML Templates**:
     - Deliver identical visual polish using **Pure Tailwind CSS utilities & keyframes** without forcing React runtime:
       - *Bento Grid*: Asymmetric CSS Grid (`grid-cols-1 md:grid-cols-3 gap-4` with col/row spans).
       - *Infinite Marquee*: CSS `@keyframes marquee` with flex containers.
       - *Magic Card Glow*: Radial gradient masks (`bg-[radial-gradient(...)]`) with hover border transitions.
       - *Retro Grid*: SVG background grid with CSS perspective transform and fade mask.
2. **Design System & Motion Budget**:
   - Adhere to design tokens in `docs/DESIGN.md`: dark base (`#09090b` / `#0f172a`), crisp 1px borders (`border-border` / `#27272a`), 5-state interactive contracts (default, hover, active, disabled, loading).
   - Limit high-motion effects to maximum 1–2 per visible viewport to preserve 60fps performance and WCAG accessibility (`motion-reduce`).


