# Spec: CI Checks

## ADDED Requirements

### Requirement: Formatting Check Runs Real Tools

The `fmt-check` recipe SHALL verify formatting using the same tools as the root `fmt` recipe, but in check-only mode, without requiring a nix dev shell.

#### Scenario: Files are correctly formatted

- **WHEN** `just ci fmt-check` is invoked
- **THEN** `dprint check` runs and exits 0
- **AND** `nixfmt --check` runs on all tracked `.nix` files and exits 0

#### Scenario: Files have formatting errors

- **WHEN** a file has incorrect formatting
- **THEN** the relevant tool reports the error and exits non-zero

### Requirement: Lint Check Runs Real Tools

The `lint-check` recipe SHALL run all linters directly without requiring a nix dev shell.

#### Scenario: Files are lint-clean

- **WHEN** `just ci lint-check` is invoked
- **THEN** `typos` checks `.`, `.github`, and `.vscode`
- **AND** `zizmor` checks `.`
- **AND** `selfup --list -check` verifies pinned versions
- **AND** all exit 0

### Requirement: Test Placeholder Fails Explicitly

The `test` recipe SHALL NOT silently pass while unconfigured.

#### Scenario: Test is run before a runner is configured

- **WHEN** `just ci test` is invoked
- **THEN** it prints a message indicating no test runner is configured
- **AND** exits non-zero
