# anylang-template

[![CI - Nix Status](https://github.com/Joaqim/anylang-template/actions/workflows/ci-nix.yml/badge.svg?branch=main)](https://github.com/Joaqim/anylang-template/actions/workflows/ci-nix.yml?query=branch%3Amain+)

A template that is not exclusive to one programming language.\
Provides a basic setup for editors, documents, and GitHub Actions.

## Prerequisites

- **Nix** — Install via [the Nix installer](https://nixos.asia/en/install). New to Nix? See the [Nix First Steps](https://nixos.asia/en/nix-first) tutorial.

## Coding Agent Setup

This repo uses [APM](https://microsoft.github.io/apm/) (via [srid/agency](https://github.com/srid/agency)) for coding agent configuration. To set up your coding agent environment:

```bash
just agent       # deploy APM primitives + launch agent (default: claude)
just agent::apm  # deploy only, don't launch
```

Override the agent with `AI_AGENT`:

```bash
AI_AGENT=opencode just agent
AI_AGENT='claude --dangerously-skip-permissions' just agent
```

Project instructions live in `agent/.apm/instructions/` and deploy to `.claude/rules/` (or equivalent) via `apm install`.

## Repo Structure

TODO
