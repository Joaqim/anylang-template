# Proposal: Wire CI Placeholders

## Why

The CI module (`ci/mod.just`) has echo placeholders for `fmt-check`, `lint-check`, and `test`, while the root justfile contains the real implementations. This means CI runs succeed without actually checking anything.

## What Changes

- `fmt-check` will run `dprint check` and `nixfmt --check` directly — no nix shell wrapper
- `lint-check` will run `typos`, `zizmor`, and `selfup --check` directly — no nix shell wrapper
- `test` will remain a placeholder but exit non-zero to signal it's not wired up
- The CI workflow installs tools directly (dprint, typos, zizmor, nixfmt) rather than bootstrapping nix for these simple checks
- Nix-specific checks (`nix flake check`, `nix build`) belong in a separate workflow

## Capabilities

### Modified Capabilities

- `ci-formatting-check`: Runs actual formatting verification instead of echo
- `ci-lint-check`: Runs actual linting instead of echo

## Impact

- `ci/mod.just`: fmt-check and lint-check bodies call tools directly; test body exits non-zero with guidance message; `nix_shell` variable scoped to only the `smoke` recipe
