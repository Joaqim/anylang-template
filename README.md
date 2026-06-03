# anylang-template

[![CI - Nix Status](https://github.com/kachick/anylang-template/actions/workflows/ci-nix.yml/badge.svg?branch=main)](https://github.com/kachick/anylang-template/actions/workflows/ci-nix.yml?query=branch%3Amain+)

A language-agnostic project template.
Provides a minimal, reproducible development environment via Nix, plus tooling for formatting, linting, documentation, and AI-assisted development.

## What's included

- **Nix flake** — Zero flake inputs for fast evaluation; `nix develop` gives you a reproducible shell with all tools.
- **Just** (`just`) — Project tasks and recipes, modularised under `agents/` and `ci/`.
- **Agents / APM** — Agent configuration managed by [APM](https://microsoft.github.io/apm/), with shared skills from [srid/agency](https://github.com/srid/agency). `.claude/` is vendored for zero-setup; additional targets are enabled in `apm.yml`.
- **CI module** — Generic `ci/mod.just` with placeholder recipes for format, lint, test, and smoke steps.
- **Formatting & linting** — `dprint`, `typos`, `zizmor`, `nixfmt`.

## Quick start

```bash
# Enter the dev shell
nix develop

# Run the default recipe
just

# List all available recipes
just --list

# Install APM config and launch agent
just ai
```
