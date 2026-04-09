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

Project instructions live in `agents/.apm/instructions/` and deploy to `.claude/rules/` (or equivalent) via `apm install`.

## Pre-commit Hooks

This repo uses [prek](https://github.com/NumTide/prek) for pre-commit hook management with the following hooks:

- **treefmt** — Formats all code using project-specific formatters (dprint, nixpkgs-fmt)
- **gitleaks** — Detects secrets and credentials in staged files

### Setup

```bash
# Enter the dev shell
direnv allow  # or `nix develop`

# Install pre-commit hooks
just pre-commit-install
```

### Usage

Hooks run automatically on `git commit`. To run manually:

```bash
# Run all hooks on all files
just pre-commit-run

# Update hook versions
just pre-commit-update
```

### Configuration

- `.pre-commit-config.yaml` — Hook definitions
- `treefmt.toml` — Formatter configurations (dprint, nixpkgs-fmt, typos)

Hooks are automatically installed in the Nix dev shell via `shell.nix`.

## Development Workflow

### Quick Commands

```bash
just check       # Run all checks (fmt-check, security, selfup)
just fmt         # Format all files (uses treefmt)
just spellcheck  # Optional spellcheck (human-controlled)
just ci          # Run CI verification
just test        # Run tests (project-specific)
```

### Checks vs Spellcheck

**`just check`** runs on every commit and in CI:
- `treefmt --fail-on-change` — Code formatting
- `zizmor .` — Nix security audit
- `selfup` — Dependency updates check

**`just spellcheck`** is optional and human-controlled:
- `typos` — Spellchecker for code and documentation
- Not run by default in agent workflows or CI
- Use before releases or when you want polish
- See [ADR-001](./docs/adr/001-typos-checking-strategy.md) for rationale

**Why separate them?**
- Agent workflows should focus on correctness, not pedantic spelling
- Spellcheck blocks fast iteration without adding value
- Humans control when polish is needed (pre-release, documentation updates)

### Quality Standards

This template enforces [code-police rules](agents/.apm/instructions/code-police-rules.instructions.md):
- No flake inputs (maintain zero-input performance)
- Justfile doc comments required
- Pre-commit hooks must be installed
- Use treefmt, not direct formatter calls
- Test recipe must be overridden in projects

## Agentic Coding Workflow

### Quick Start

Launch an agent with your preferred tool and use the `/do` command:

```bash
# Launch Claude Code with the agentic workflow
just agent

# Or launch OpenCode
AI_AGENT=opencode just agent
```

### The `/do` Workflow

`/do` runs a fully autonomous pipeline from start to PR:

1. **Sync** — Updates dependencies, checks for breaking changes
2. **Research** — Reads documentation, explores code, gathers context
3. **Branch & PR** — Creates a feature branch with placeholder PR
4. **Implement** — Writes the actual code changes
5. **Check** — Runs `just check` (typecheck, static analysis)
6. **Fmt** — Runs `just fmt` (code formatting)
7. **Docs** — Updates README.md with user-facing changes
8. **Police** — Runs `code-police` skill (3-pass quality gate)
9. **Test** — Runs relevant tests only (smart test selection)
10. **CI** — Runs `just ci` or equivalent CI verification
11. **Update PR** — Updates the PR description with full context
12. **Done** — Final verification and cleanup

Each step has verification checkpoints. If something fails, `/do` pauses and lets you decide whether to continue or abort.

### The `/talk` Workflow

For exploration and discussion without making changes:

```bash
/talk <your question>
```

Use this to:
- Explore the codebase together
- Discuss architecture decisions
- Research approaches before implementation
- Debug issues interactively

`/talk` runs in read-only mode — no file changes allowed.

### Available Skills

**`hickey`** — Structural simplicity evaluation using [Rich Hickey's "Simple Made Easy"](https://www.infoq.com/presentations/Simple-Made-Easy/). Catches accidental complexity that tests can't.

**`code-police`** — Three-pass quality gate:
1. **Rules check** — Validates against generic + project-specific rules
2. **Fact-check** — Detects logic errors and inconsistent states
3. **Elegance review** — Iterative refinement for clarity and simplicity

**`forge-pr`** — Writes PR titles and descriptions developers actually want to read. Paragraphs over bullet lists, substance over boilerplate.

### Customizing for Your Project

Project-specific instructions live in `agents/.apm/instructions/`:

- **`workflow.instructions.md`** — Define your check, fmt, test, and CI commands. `/do` reads these to know how to verify your work.

  ```markdown
  ---
  description: Workflow commands for the /do pipeline
  applyTo: "**"
  ---

  ## Check command
  `just check` — fast static-correctness gate

  ## Format command
  `just fmt`

  ## Test command
  `just test` — run only tests for changed code paths

  ## CI command
  `just ci` — verify by checking exit code 0
  ```

- **`code-police-rules.instructions.md`** — Add project-specific quality rules that `code-police` checks alongside the built-in ones.

  ```markdown
  ---
  description: Project-specific code-police rules
  ---

  ## Code Police Rules

  ### no-raw-sql
  Use the query builder for all database access. No raw SQL strings outside migrations.
  ```

- **`architecture.instructions.md`** — Document architectural constraints that must stay in sync with `README.md`.

After editing `agents/.apm/instructions/`, run:

```bash
just agent::apm  # Regenerate .claude/ with new instructions
```

### Why `.claude/` is Vendored

The generated `.claude/` directory is **committed to git** instead of being gitignored. This is intentional:

- **Branch protection enforces `apm-sync`** — No PR can merge if `.claude/` is out of sync with `.apm/` sources. This is a platform-level guardrail.
- **Zero-setup for agents** — Claude Code works immediately after checkout, no `apm install` step needed. New worktrees get rules, skills, and hooks for free.
- **GitHub-browsable** — Anyone can read `.claude/rules/` on GitHub to understand the agent config without cloning.

The single source of truth remains `apm.yml` + `agents/.apm/`. Edit sources there, run `just agent::apm`, and commit the result.

### Workflow Commands

The `/do` workflow expects these commands to be available:

```bash
just check   # Run all checks (fmt-check, security, selfup)
just fmt     # Format all files (uses treefmt)
just ci      # Run CI verification (calls check)
just test    # Run tests (project-specific, override as needed)
```

These are provided at the template level. For project-specific implementations, override them in a project-specific justfile module.

## Performance

### Zero-Input Flake Design

This flake intentionally has **zero inputs**. Instead of the flake input system, nixpkgs is imported via `fetchTarball` in `nix/nixpkgs.nix` and pinned with npins.

**Why?** Each flake input adds ~1.5s to cold eval due to fetcher-cache verification. Even a single nixpkgs input costs ~7s. With zero inputs:
- **Cold eval**: ~2.5s (first run after cache clear)
- **Warm eval**: ~1.6s (subsequent runs with cache)

### Benchmarks

Tested on the following hardware:

| Component | Specification |
|-----------|---------------|
| CPU | Intel Core i5-6600K @ 3.50GHz (4 cores, 1 thread/core) |
| RAM | 15 GB |
| OS | NixOS (Linux 6.18.20) |
| Nix | 2.31.3 |
| System | x86_64-linux |

**Eval times measured with `time nix develop path:. -c echo "done"`:**

| Condition | Time | Notes |
|-----------|------|-------|
| Cold (cache cleared) | 2.477s | After `rm -rf ~/.cache/nix/eval-cache-v6/` |
| Warm 1 | 2.615s | First run after cold |
| Warm 2 | 1.880s | |
| Warm 3 | 1.602s | |
| Warm 4 | 1.749s | |

**Observations:**
- Cold eval matches the expected ~2.6s closely (2.477s measured)
- Warm eval settles around 1.6-1.9s, not the claimed 0.3s
- The 0.3s claim likely comes from faster hardware (SSD, newer CPU) or different Nix configuration
- The zero-input design still provides significant benefit over flake-input-based approaches (which would be 7s+ cold)

### Remote Builder

For faster builds on this hardware, configure a remote builder:

```bash
# ~/.config/nix/machines
jq@desktop.zt x86_64-linux /etc/nix/signingkey.pub 16 big-parallel,kvm,nixos-test
```

This enables parallel building across 16 jobs with support for virtualization tests.

## Repo Structure

TODO
