# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.3.x   | :white_check_mark: |
| 1.2.x   | :white_check_mark: |
| < 1.2.0 | :x:                |

## Security Invariants

The Universal Vibe Coding Standard strictly enforces the following security boundaries:
1. **Zero Plain-Text Secrets**: No API keys, credentials, private tokens, or exchange secrets should ever be committed to documentation or code. Use environment pointers (`.env`) exclusively.
2. **Strictly Additive Operations**: Scaffolding scripts are designed to be non-destructive. They never overwrite, rename, or delete existing source code, configuration files, strategies, or data directories.
3. **Restricted Command Execution**: Automated helpers do not execute arbitrary shell commands or send network requests outside of standard package manager commands (e.g. `npx shadcn@latest`).

## Reporting a Vulnerability

If you discover a security vulnerability or credential leak loophole within this project:
- Please do **not** open a public issue.
- Report the vulnerability responsibly by opening a GitHub Private Security Advisory on this repository.
- We will review and publish a fix promptly.
