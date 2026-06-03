# Design: Wire CI Placeholders

## Context

`ci/mod.just` is a just submodule that runs from `ci/` with `working-directory` set to `..` (repo root). The root justfile has real tool commands wrapped in `{{ nix_shell }}`. The CI module should call tools directly to avoid the nix bootstrap overhead for simple checks.

## Goals / Non-Goals

**Goals:**

- Replace echo placeholders with real tool invocations
- Keep CI module self-contained — no dependency on nix for lint/format
- Preserve the `smoke` recipe's nix dependency (it needs `nix build`)

**Non-Goals:**

- Modifying the GitHub Actions workflow (separate concern)
- Adding `nix flake check` or nix-specific CI (belongs in a separate workflow)
- Changing the root justfile's `nix_shell` pattern

## Decisions

### Decision 1: Call tools directly, no nix_shell wrapper

The `nix_shell` variable in `ci/mod.just` is only needed for `smoke` (which calls `nix build`). For `fmt-check` and `lint-check`, tools are called directly. The CI runner is responsible for installing them.

### Decision 2: Mirror root justfile commands

The commands in `ci/mod.just` should match the root justfile's `fmt` and `lint` recipes in check-only mode, ensuring consistent behavior whether run locally or in CI.
