# Contributing to Universal Vibe Coding Standard

Thank you for your interest in contributing to the **Universal Vibe Coding Standard** plugin! This project aims to provide a universal, robust living documentation and multi-conversation memory standard for AI pair programming.

---

## 🛠 How You Can Contribute

1. **New Domain Scaffolding Detectors**:
   - Enhance `skills/project-blueprints/scripts/scaffold.ps1` to detect additional frameworks (e.g., Elixir Phoenix, Ruby on Rails, Unity/Godot, Flutter).
2. **Dashboard Visual Enhancements**:
   - Improve `skills/project-blueprints/templates/index.html` with new tabs, export options, or dark/light theme toggles while maintaining the zero-dependency offline guarantee.
3. **Specialized Agent Skills**:
   - Add new reusable skills under `skills/` for specific engineering domains.
4. **Bug Reports & Invariant Hardening**:
   - If you encounter Mermaid syntax errors, path resolution quirks on different operating systems, or edge cases, please open an Issue or PR.

---

## 📋 Development & Testing Workflow

1. **Fork & Clone**:
   ```bash
   git clone https://github.com/arup3880/universal-vibe-coding-standard.git
   cd universal-vibe-coding-standard
   ```
2. **Create a Feature Branch**:
   ```bash
   git checkout -b feat/enhance-domain-detection
   ```
3. **Test Non-Destructive Invariants**:
   - Run `scaffold.ps1` against a test project folder.
   - Verify that existing code is NEVER modified or deleted.
   - Verify that Mermaid diagrams render without syntax errors in `index.html`.
4. **Submit a Pull Request**:
   - Describe your changes clearly with before/after behavior.
   - Ensure `plugin.json` version is incremented if introducing a release feature.

---

## 📜 Code of Conduct & Standards
- Keep all rules and scripts **domain-agnostic**.
- Enforce the **Zero Plain-Text Secrets** security rule.
- Preserve backward compatibility for existing living documentation suites.
